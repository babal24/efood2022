import pandas as pd
import matplotlib.pyplot as plt

# Load the data into a Pandas DataFrame
df = pd.read_csv("orders.csv")

# Filter the data for only the Breakfast cuisine_parent
breakfast = df[df['cuisine'] == 'Breakfast']

# Group the breakfast data by the city column
breakfast_per_city = breakfast.groupby('city').size().reset_index(name='counts')

# Plot the breakfast orders per city
plt.barh(breakfast_per_city['city'], breakfast_per_city['counts'])
plt.xlabel('Number of Orders')
plt.ylabel('City')
plt.title('Breakfast Orders per City')
plt.gca().invert_yaxis()
plt.show()


