from firebase_functions import https_fn
from firebase_admin import initialize_app, storage
from typing import Any
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tensorflow.keras.models import load_model

initialize_app()

model = None

METADATA = "keras_metadata.pb"
SAVED_MODEL = "saved_model.pb"
VAR_DATA = "variables.data-00000-of-00001"
VAR_INDEX = "variables.index"


@https_fn.on_call()
def getanalysis(req: https_fn.CallableRequest) -> Any:
    global model

    file_link = req.data["fileUrl"]
    content_header = req.data["contentHeader"]
    datadump_id = req.data["dumpId"]
    og_name = req.data["name"]
    uid = req.auth.uid

    df = pd.read_excel(file_link)
    bucket = storage.bucket()

    if model == None:
        var_data_blob = bucket.blob(VAR_DATA)
        var_index = bucket.blob(VAR_INDEX)
        saved_model = bucket.blob(SAVED_MODEL)
        metadata = bucket.blob(METADATA)
        os.makedirs("model/assets")
        os.makedirs("model/variables")
        var_data_blob.download_to_filename(f"model/variables/{VAR_DATA}")
        var_index.download_to_filename(f"model/variables/{VAR_INDEX}")
        saved_model.download_to_filename(f"model/{SAVED_MODEL}")
        metadata.download_to_filename(f"model/{METADATA}")
        model = load_model("model")
        os.remove(f"model/variables/{VAR_DATA}")
        os.remove(f"model/variables/{VAR_INDEX}")
        os.remove(f"model/{SAVED_MODEL}")
        os.remove(f"model/{METADATA}")
        os.removedirs("model/assets/")
        os.removedirs("model/variables/")
    labels = ["Positive", "Negative", "Neutral"]
    preds = np.argmax(model.predict(df[content_header]), axis=-1)
    new_df = pd.DataFrame(
        {
            "Comment": df[content_header],
            "Prediction": preds
        }
    )
    new_df["Prediction"] = new_df["Prediction"].apply(lambda x: labels[x])
    labels = new_df["Prediction"].value_counts().index.to_list()
    sizes = new_df["Prediction"].value_counts().to_list()
    plt.figure()
    plt.pie(
        sizes[::-1], labels=labels[::-1],
        explode=[0.01, 0.01, 0.01],
        autopct="%1.f%%",
        colors=["#80b9ff", "#2775d6","#2f78ed"]
    )
    plt.title(f"Sentiment Composition for {og_name.upper()}")
    plt.savefig("temp_fig.png")
    new_df.to_excel("temp_file.xlsx")
    blob_analysis_excel = bucket.blob(f"{uid}/analysisExcel/{datadump_id}/{og_name}_sentiments.xlsx")
    blob_analysis_pie = bucket.blob(f"{uid}/analysisPie/{datadump_id}/{og_name}_pie.png")
    blob_analysis_excel.upload_from_filename("temp_file.xlsx")
    blob_analysis_pie.upload_from_filename("temp_fig.png")

    return {"success": True}