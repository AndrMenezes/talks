import numpy as np
import pandas as pd
from pybats.dglm import dlm
from pybats_detection.monitor import Monitoring

data = pd.read_csv("simulated_data.csv")
data_location = data[data["change"] == "location"].reset_index(drop=True)
data_scale = data[data["change"] == "scale"].reset_index(drop=True)

###############################################################################
# Location simulated data
a = np.array([100])
R = np.eye(1)
R[[0]] = 100
mod = dlm(a, R, ntrend=1, deltrend=0.95)
monitor = Monitoring(mod=mod)
monitor_results = monitor.fit(
    y=data_location["y"],
    h=4, tau=0.135,
    discount_factors={"trend": [0.10]},
    distr_type="location",
    bilateral=True,
    prior_length=10)
no_monitor_results = monitor.fit(
    y=data_location["y"],
    h=10000, tau=0.135,
    discount_factors={"trend": [0.20]},
    distr_type="location",
    bilateral=True,
    prior_length=4)

df_monitor = monitor_results["filter"]["predictive"].copy()
df_no_monitor = no_monitor_results["filter"]["predictive"].copy()

cols = ["t", 'with_monitor', 'what_detected', 'y', 'f', 'q', 'ci_lower',
        'ci_upper']
df_monitor["with_monitor"] = True
df_no_monitor["with_monitor"] = False
df_out = pd.concat([df_monitor[cols], df_no_monitor[cols]])
df_out.to_csv("location_simulated_data__results.csv", index=False)


###############################################################################
# Scale simulated data
a = np.array([100])
R = np.eye(1)
R[[0]] = 100
mod = dlm(a, R, ntrend=1, deltrend=0.95)
monitor = Monitoring(mod=mod)
monitor_results = monitor.fit(
    y=data_scale["y"],
    h=4, tau=0.135,
    discount_factors={"trend": [0.10]},
    distr_type="scale",
    prior_length=10)
no_monitor_results = monitor.fit(
    y=data_scale["y"],
    h=10000, tau=0.135,
    discount_factors={"trend": [0.20]},
    distr_type="scale",
    prior_length=4)

df_monitor = monitor_results["filter"]["predictive"].copy()
df_no_monitor = no_monitor_results["filter"]["predictive"].copy()

cols = ["t", 'with_monitor', 'what_detected', 'y', 'f', 'q', 'ci_lower',
        'ci_upper']
df_monitor["with_monitor"] = True
df_no_monitor["with_monitor"] = False
df_out = pd.concat([df_monitor[cols], df_no_monitor[cols]])
df_out.to_csv("scale_simulated_data__results.csv", index=False)
