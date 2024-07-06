import pandas as pd
data = pd.read_csv('Ukraine.csv')
data['event_date'] = pd.to_datetime(data['event_date'], format='%d %B %Y').dt.strftime('%Y-%m-%d')
data.to_csv('Ukraine_updated.csv', index=False)