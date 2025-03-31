### Notez: Gestione Note 📝

---

#### **Funzionalità Principali** 🚀

1. **Creazione di Note**  
   ➡️ Gli utenti possono creare nuove note cliccando sul pulsante `+` nella schermata principale.  
   ➡️ Ogni nota include un titolo, un contenuto testuale e tag opzionali.

2. **Modifica di Note**  
   ✏️ È possibile modificare una nota esistente toccandola nella lista per aprirla nella schermata di modifica.

3. **Eliminazione di Note**  
   🗑️ Le note possono essere eliminate cliccando sull'icona del cestino nella scheda della nota.

4. **Ricerca di Note**  
   🔍 Una barra di ricerca consente di filtrare le note per titolo o tag.  
   ➡️ La ricerca è **case-insensitive** e supporta corrispondenze parziali.

5. **Gestione dei Tag**  
   🏷️ I tag sono memorizzati come stringhe separate da virgole e possono essere gestiti tramite metodi helper (`getTagList` e `setTagList`).

6. **Persistenza dei Dati**  
   💾 Utilizzo di **ObjectBox** per la gestione del database locale, garantendo operazioni CRUD rapide ed efficienti.

7. **Gestione dello Stato**  
   🔄 **Riverpod** è utilizzato per gestire lo stato dell'applicazione e aggiornare l'interfaccia utente quando i dati cambiano.

---

#### **Problemi Riscontrati e Soluzioni** 🛠️

1. **Sicurezza Null-Safety**  
   - Il campo `id` del modello `Note` è stato reso nullable (`int?`) per gestire i casi in cui l'ID viene assegnato da ObjectBox.  
   - È stato necessario aggiungere controlli per evitare errori a runtime quando si accede a `id`.

2. **Implementazione di `SearchDelegate`**  
   - La classe `SearchDelegate` richiede implementazioni concrete per i metodi `buildActions`, `buildLeading`, `buildResults` e `buildSuggestions`.  
   - Errori come `'NoteSearchDelegate.buildActions' non è un override valido` sono stati risolti assicurando che i metodi restituissero i tipi corretti (es. `List<Widget>` per `buildActions`).

3. **Errore con `PropertyType` in ObjectBox**  
   - L'annotazione `@Property(type: PropertyType.string)` sul campo `tags` ha causato errori.  
   - È stata rimossa poiché il tipo `String` è già il valore predefinito.

4. **Aggiornamento dello Stato**  
   - Dopo l'eliminazione di una nota, l'interfaccia utente non si aggiornava automaticamente.  
   - Risolto invalidando il provider con `ref.invalidate(objectBoxProvider)`.

5. **Gestione della Query di Ricerca**  
   - La variabile `searchQuery` non veniva aggiornata correttamente quando il delegato di ricerca restituiva un risultato.  
   - Risolto aggiornando `searchQuery` nel callback `onPressed`.

6. **Messaggi di Errore Generici**  
   - I messaggi di errore nei callback `when` di `AsyncValue` erano troppo generici.  
   - Migliorati includendo i dettagli effettivi dell'errore per facilitare il debug.

---

#### **Come Eseguire il Progetto** ▶️

1. **Prerequisiti**  
   - Installa Flutter SDK.  
   - Installa ObjectBox CLI per generare i binding di ObjectBox.  
   - Usa un editor di codice come Visual Studio Code o Android Studio.

2. **Setup**  
   - Clona il repository sul tuo computer.  
   - Esegui il comando:
     ```bash
     flutter pub get
     ```
   - Genera i binding di ObjectBox con:
     ```bash
     flutter pub run build_runner build
     ```

3. **Esecuzione**  
   - Avvia l'app con il comando:
     ```bash
     flutter run
     ```

---

#### **Miglioramenti Futuri** 🌟

1. **Gestione Avanzata dei Tag**  
   - Aggiungere un'interfaccia dedicata per gestire i tag invece di utilizzare stringhe separate da virgole.

2. **Ordinamento e Filtri**  
   - Consentire agli utenti di ordinare le note per data di creazione, titolo o tag.  
   - Aggiungere opzioni di filtro avanzate.

3. **Segnalazione degli Errori**  
   - Implementare un meccanismo centralizzato per la gestione e il monitoraggio degli errori.

4. **Miglioramenti UI**  
   - Migliorare il design delle schede delle note e della barra di ricerca per un aspetto più moderno.

5. **Test Unitari**  
   - Aggiungere test unitari per il modello `Note`, la funzionalità di ricerca e le operazioni del database.

---

#### **Ringraziamenti** 🙌
- **Flutter** per il framework versatile per lo sviluppo di app multipiattaforma.  
- **ObjectBox** per la soluzione di database veloce ed efficiente.  
- **Riverpod** per la gestione dello stato semplice e potente.
