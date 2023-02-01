import matplotlib.pyplot as plt
import pandas as pd

# Load the breakfast orders data into a Pandas DataFrame
df = pd.read_csv("orders.csv")

# Filter the data for only the Breakfast cuisine_parent
breakfast = df[df['cuisine'] == 'Breakfast']

# Plot the total number of breakfast orders per city
breakfast_city = breakfast.groupby('city').agg({'user_id': 'count'}).reset_index()
breakfast_city.plot(x='city', y='user_id', kind='bar', color='red')
plt.xlabel('City')
plt.ylabel('Number of Orders')
plt.title('Total Number of Breakfast Orders per City')
plt.show()

# Plot the average price of breakfast orders per city
breakfast_city = breakfast.groupby('city').agg({'amount': 'mean'}).reset_index()
breakfast_city.plot(x='city', y='amount', kind='bar', color='blue')
plt.xlabel('City')
plt.ylabel('Average Price')
plt.title('Average Price of Breakfast Orders per City')
plt.show()


