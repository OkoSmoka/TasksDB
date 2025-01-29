1. Cel bazy danych

Baza danych została zaprojektowana na potrzeby systemu zarządzania zadaniami, który umożliwia użytkownikom tworzenie, 

aktualizowanie, usuwanie oraz udostępnianie zadań. System wspiera organizacje posiadające strukturę hierarchiczną, 

gdzie użytkownicy mogą mieć przypisanych przełożonych oraz podwładnych.


2. Struktura bazy danych

Baza danych składa się z następujących tabel:

Tenants - przechowuje informacje o najemcach (Tenants).

Users – przechowuje informacje o użytkownikach systemu, w tym identyfikator najemcy (TenantId), przełożonego (ManagerId) i rolę użytkownika.

Tasks – zawiera zadania przypisane do użytkowników, z danymi takimi jak priorytet, opis, status oraz daty utworzenia i ostatniej aktualizacji.

TaskShares – przechowuje informacje o udostępnieniu zadań innym użytkownikom.

TaskHistory – rejestruje zmiany w zadaniach, zapisując ich wcześniejsze wartości oraz użytkownika, który dokonał modyfikacji.

ErrorLogs – loguje błędy występujące w bazie danych.


3. Dostępne operacje

3.1. Procedury składowane

AddTask – dodaje nowe zadanie do bazy.

UpdateTask – aktualizuje istniejące zadanie, zapisując zmiany w tabeli historii.

DeleteTask – usuwa zadanie oraz jego powiązania w TaskShares.

ShareTask – umożliwia udostępnienie zadania innemu użytkownikowi.

GetUserTasks – zwraca listę zadań przypisanych do użytkownika.

GetSubordinateTasks – zwraca zadania podwładnych użytkownika.

GetTaskHistory – zwraca historię zmian dla danego zadania.

GetTaskStatisticsByManager – generuje statystyki dotyczące zadań zarządzanych przez danego menedżera.

3.2. Testy procedur

Dla każdej procedury został przygotowany odpowiedni skrypt testujący, który:

Sprawdza poprawność działania procedur.

Weryfikuje poprawność usuwania, aktualizowania i udostępniania zadań.

Symuluje scenariusze błędne, np. próbę usunięcia zadania przez nieistniejącego użytkownika.


4. Usprawnienia zastosowane w bazie danych

Indeksowanie – zastosowano indeksy na kluczowych kolumnach, aby przyspieszyć wyszukiwanie, np. IDX_Tasks_UserId_CreatedAt_Status.

Obsługa błędów – dodano mechanizmy rejestrujące błędy w tabeli ErrorLogs.

Zarządzanie historią zmian – każda modyfikacja zadania jest zapisywana w tabeli TaskHistory.


5. Możliwe udoskonalenia

Bezpieczeństwo operacji – możliwość usuwania i udostępniania zadań mają mieć tylko menedżerowie.

Terminowość zadań - dodanie daty do której ma być wykonane każde zadanie. 

Optymalizacja indeksów – analiza użycia indeksów i dostosowanie ich do rzeczywistych zapytań wykonywanych przez system.

Wprowadzenie mechanizmu archiwizacji – automatyczne przenoszenie zadań zakończonych do osobnej tabeli w celu poprawy wydajności.

Zbudowanie systemu powiadomień – dodanie automatycznych powiadomień e-mailowych o zmianach w zadaniach i przypomnienia o zbliżających się deadline-ach.
