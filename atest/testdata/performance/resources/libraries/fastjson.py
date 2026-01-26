
def get_value(body, path):
    """
    body: Python dict
    path: Robot-style "[data][0][attributes][name]"
    """
    # strip leading/trailing brackets & quotes, split on ']['
    keys = path.strip("[]").split("][")
    cur = body
    for k in keys:
        # numeric indices become ints
        if k.isdigit():
            cur = cur[int(k)]
        else:
            cur = cur[k]
    return cur
