# 📌 Query SQL per la Gestione delle Palestre

## 🏋️‍♂️ Elenco delle Attività Disponibili il Mercoledì in una Città
**Descrizione:** Questa query restituisce l'elenco delle attività disponibili in una città specifica il mercoledì, includendo il nome della palestra, la tipologia di attività, l'orario, il numero massimo di posti disponibili e il prezzo, ordinati per palestra.

### **SQL:**
```sql
SELECT
    p.nome AS palestra,
    a.tipo AS attivita,
    o.ora AS orario,
    o.capienza AS posti_disponibili,
    o.prezzo
FROM offerta o
JOIN ha h ON o.id = h.idOfferta
JOIN palestra p ON h.idPalestra = p.id
JOIN attivita a ON o.idAttivita = a.id
WHERE o.giorno_settimana = 'Mercoledi' AND p.citta = 'Milano'
ORDER BY p.nome;
```

### **📊 Risultato:**
| Palestra  | Attività | Orario | Posti Disponibili | Prezzo |
|-----------|---------|--------|-------------------|--------|
| Gym One  | Yoga    | 18     | 20                | 15     |

---

## 💰 Importo Totale delle Prenotazioni di Aprile per una Palestra
**Descrizione:** Questa query calcola l'importo totale delle prenotazioni effettuate dagli abbonati nel mese di aprile per una specifica palestra.

### **SQL:**
```sql
SELECT
    p.nome AS palestra,
    SUM(o.prezzo) AS totale_incasso_aprile
FROM prenotazioni pr
JOIN offerta o ON pr.idOfferta = o.id
JOIN ha h ON o.id = h.idOfferta
JOIN palestra p ON h.idPalestra = p.id
WHERE MONTH(pr.data_prenotazione) = 4
AND YEAR(pr.data_prenotazione) = 2024
AND p.id = 1
GROUP BY p.nome;
```

### **📊 Risultato:**
| Palestra | Totale Incasso Aprile |
|----------|----------------------|
| Gym One  | 30                   |

---

## 🏆 Classifica Annuale delle Palestre per Numero di Prenotazioni
**Descrizione:** Questa query restituisce la classifica annuale delle palestre in una determinata città, ordinate per numero di attività prenotate.

### **SQL:**
```sql
SELECT
    p.nome AS palestra,
    COUNT(pr.idOfferta) AS numero_prenotazioni
FROM prenotazioni pr
JOIN offerta o ON pr.idOfferta = o.id
JOIN ha h ON o.id = h.idOfferta
JOIN palestra p ON h.idPalestra = p.id
WHERE YEAR(pr.data_prenotazione) = 2024
AND p.citta = 'Roma'
GROUP BY p.nome
ORDER BY numero_prenotazioni DESC;
```

### **📊 Risultato:**
| Palestra      | Numero Prenotazioni |
|--------------|--------------------|
| FitLife      | 2                  |
| Sport Center | 1                  |

