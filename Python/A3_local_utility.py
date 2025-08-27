ARMA3_LOGFILE_DIRECTORY = r"C:\Users\krend\AppData\Local\Arma 3"


def find_latest_rpt_file():
    """Find the most recently modified .rpt file in a directory."""
    import glob
    import os
    rpt_files = glob.glob(os.path.join(ARMA3_LOGFILE_DIRECTORY, "*.rpt"))
    if not rpt_files:
        raise FileNotFoundError("No .rpt files found in the directory.")

    latest_file = max(rpt_files, key=os.path.getmtime)
    return latest_file
