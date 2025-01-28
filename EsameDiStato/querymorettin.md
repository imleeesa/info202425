# Gym Management Query

This project contains a SQL query to retrieve information about gym offers in Rome on Wednesdays.

## Query

The SQL query retrieves the following information:
- Gym name (`palestra`)
- Activity type (`tipologia_attività`)
- Offer hour (`orario_svolgimento`)
- Maximum capacity (`posti_massimi`)
- Price (`prezzo`)

### SQL Query

```sql
SELECT 
    gym.name AS palestra,
    activity.type AS tipologia_attività,
    offer.hour AS orario_svolgimento,
    offer.capacity AS posti_massimi,
    offer.price AS prezzo
FROM 
    gym
JOIN has ON gym.id = has.idGym
JOIN offer ON has.idOffer = offer.id
JOIN activity ON offer.idAct = activity.id
WHERE 
    gym.city = 'Rome'
    AND offer.weekday = 'Wednesday'
ORDER BY 
    palestra;