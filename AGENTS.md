# AGENTS.md — wytyczne i kontekst projektu

Ten plik jest przeznaczony dla asystentów AI (i nowych osób w zespole) pracujących w repozytorium
`Projekt`. Opisuje, czym jest projekt, gdzie leżą materiały, jak pisać dokumenty i czego nie robić.
W razie sprzeczności obowiązuje kolejność: polecenie użytkownika w rozmowie → ten plik → domysł asystenta.

---

## 1. Czym jest ten projekt

Przedmiot: **Projektowanie doświadczeń użytkownika** (PWr, Semestr 2, prowadząca wykład: Bernadetta Maleszka, prowadząca projekt: Agnieszka Indyka-Piasecka).
Zespół czteroosobowy: Natalia Suda, Hubert Tański, Kacper Tomczyk, Jakub Borsuk.

Wariant projektu: **REDESIGN**, czyli rozszerzanie i poprawianie istniejącej aplikacji, a nie budowa
nowej od zera. Aplikacja źródłowa to opracowany **dwa semestry temu** „Informator o przerwach w dostawach
usług oraz mediów”: makieta mobilna w Figmie, makiety papierowe oraz udokumentowane testy moderowane
z pięcioma użytkownikami. Redesign polega na dodaniu funkcjonalności, których w makiecie brakowało, oraz na
naprawie elementów, które w testach wypadły źle.

Materiały źródłowe powstały na **wcześniejszym kursie**, w ramach którego praca nad projektem kończyła się
na etapie makiety interaktywnej — nie prowadzono tam implementacji ani badań z właściwymi użytkownikami
systemu. Wszystko, co znajduje się w `materialy/archival/`, pochodzi z tamtego okresu i jest materiałem
historycznym. Katalog `materialy/` (poza `archival/`) jest przeznaczony na informacje zbierane **na bieżąco**
w tym semestrze: nowe notatki z badań, wywiady, materiały z zajęć i uzgodnienia zespołu. Nie mieszaj tych
dwóch warstw i nie traktuj archiwum jako źródła aktualnych danych o użytkownikach.

Cel projektu w wymaganym formacie („Chcemy rozwiązać problem … dotyczący grupy … po to, aby …”)
znajduje się w rozdziale 1 dokumentacji i jest cytowany w `../TOPIC.md`. Nie zmieniaj jego treści bez
polecenia — jest to sformułowanie wymagane przez instrukcję i oddawane prowadzącej.

Platforma docelowa: aplikacja mobilna (Android i iOS) z powiadomieniami push oraz opcjonalnym SMS.
Technologia implementacji nie została jeszcze wybrana — w dokumentacji jest oznaczona jako TODO.

---

## 2. Etapy i dokument oddawany prowadzącej

Projekt jest realizowany etapami; numer zajęć jest jednocześnie terminem oddania etapu. Etapy 1–3 są
wspólne dla obu wariantów instrukcji, rozgałęzienie następuje od etapu 4.

| Etap | Zajęcia | Zakres w wariancie REDESIGN |
|---|---|---|
| 1 | 3 | użyteczność serwisów internetowych (oddzielny raport, poza tym repo) |
| 2 | 4 | specyfikacja projektu: metody badań, cel, zadania, grupa docelowa, technologia |
| 3 | 5 | kontekst i przypadki użycia: persony, historyjki, przypadki użycia, scenariusze, funkcjonalności, SWOT, QFD |
| 4 | 6 | scenariusze badań, przegląd kognitywny, GOMS, KLM/TLM, miary użyteczności |
| 5 | 7 | badania użyteczności z eye-trackingiem lub śledzeniem myszy, heurystyki Nielsena |
| 6 | 9 | poprawa interfejsu, implementacja, dwie wersje UI dla 2–3 funkcjonalności, instrukcja, wsparcie użytkownika |
| 7 | 12 | ponowne badania z właściwymi użytkownikami |
| 8 | 13 | badania z osobami z innych grup (obecność obowiązkowa) |
| 9 | 14 | raport i prezentacja końcowa, poprawki |

Głównym artefaktem jest **`dokumentacja-projektu.md`** — oficjalna dokumentacja projektu, którą użytkownik
dostarcza prowadzącej w coraz nowszych wersjach; każda wersja odpowiada kolejnemu etapowi. Dokument prowadzi
ciągłą numerację rozdziałów 1–10, odpowiadających kolejno punktom instrukcji `projekt_pdu_redesign.pdf`.
Dokument jest przeznaczony wyłącznie dla prowadzącej: nie umieszczaj w nim metryki, spisu treści, tabel
mapowania na instrukcję, historii wersji, odnośników do plików roboczych ani notatek o organizacji pracy.

---

## 3. Mapa repozytorium

| Ścieżka | Zawartość |
|---|---|
| `dokumentacja-projektu.md` | główna, oficjalna dokumentacja projektu — źródło prawdy |
| `funkcjonalnosci.md` | materiał roboczy: karty funkcjonalności z wymaganiami FR i miarami |
| `README.MD` | odnośniki do makiety w Figmie i tablicy Trello |
| `materialy/` | informacje zbierane na bieżąco w tym semestrze: notatki z badań, nowe wywiady, materiały z zajęć, uzgodnienia zespołu |
| `materialy/archival/` | archiwum sprzed dwóch semestrów, z pierwotnej pracy nad projektem na wcześniejszym kursie (zakres kończył się na makiecie interaktywnej): `prompt ICK.txt` (cały ówczesny przebieg prac — analiza konkurencji, persony, historyjki, przypadki użycia, prototyp, scenariusze i wyniki testów), wywiady i wnioski (`Definicja problemu i wnioski/`), `historyjki.txt`, `REQUIREMENTS.md` |
| `projekt_pdu.pdf` | instrukcja projektu dla wariantu NOWY PROJEKT (etapy 1–3 identyczne) — tylko do odczytu |
| `../projekt_pdu_redesign.pdf` | instrukcja projektu dla wariantu REDESIGN — tylko do odczytu |
| `../wyklady/wNN.pdf` | materiały z wykładów, pojawiają się na bieżąco — tylko do odczytu |
| `../raporty/NN_nazwa-etapu/` | raporty etapowe w LaTeX, tworzone według zasad z `../AGENT.md` |

Pliki PDF (instrukcje i wykłady) są materiałem autorskim prowadzącej i materiałem wejściowym —
nie wolno ich modyfikować, nadpisywać ani generować na nowo. Nie kopiuj slajdów dosłownie; parafrazuj
i podawaj źródło w formie „wykład N”.

Odnośniki zewnętrzne (makieta i tablica zadań) są w `README.MD` i nie należy ich duplikować w innych plikach.
W oficjalnej dokumentacji projektu nie umieszczaj tych odnośników ani żadnych innych wskazań na pliki tego
repozytorium — dokument ma być samodzielny dla czytelnika z zewnątrz.

---

## 4. Jak pisać dokumenty

Wszystkie treści powstają **po polsku**, w UTF-8, stylem bezosobowym i formalnym. Nazwy plików i katalogów
są wyłącznie ASCII, małe, w kebab-case, bez spacji i polskich znaków.

Podstawową formą jest **ciągły tekst**. Punktory stosuje się oszczędnie — w praktyce tylko tam, gdzie
wyliczenie jest naprawdę czytelniejsze od zdania (na przykład podpisanie osoby odpowiedzialnej przy
funkcjonalności). Zamiast listy akapitów lepiej napisać akapit, który je łączy. Tabele są dozwolone
i zalecane tam, gdzie porządkują dane: podział odpowiedzialności, zestawienia miar, wyniki badań.

Terminy branżowe pozostają w oryginale i nie są tłumaczone: `WBS`, `RACI`, `EVM`, `CPM`, `PERT`, `SWOT`,
`TCO`, `UML`, `BPMN`, `SPI`, `CPI`, `PV`, `EV`, `AC`, a także `GOMS`, `KLM`, `TLM`, `QFD`,
`ISO 9241-210`, `usability`, `UX`, `UI`, `eye-tracking`, `persona`, `scenario`, `heurystyki Nielsena`.

Numeracja i identyfikatory są spójne w całym dokumencie: funkcjonalności jako `F1`–`F8`, przypadki użycia
jako `CU-01`–`CU-07`, wymagania szczegółowe jako `FR-x.y`, historyjki przez odniesienie do persony.
Jeżeli dodajesz nowy identyfikator, dopisz go do odpowiedniej tabeli.

**Nie wymyślaj danych z badań.** Liczby, cytaty, daty, wyniki testów i charakterystyki uczestników pochodzą
od zespołu. Brak danych oznaczaj kursywą, na przykład `*TODO — uzupełnić opisy rozmówców.*`, z krótkim
wskazaniem, czego brakuje. Rozdział, którego etap jeszcze się nie odbył, zawiera wyłącznie taki znacznik
i nic więcej. Lepiej zostawić uczciwe TODO niż wiarygodnie wyglądającą fikcję, która trafi do prowadzącej.

---

## 5. Struktura dokumentacji i zasady jej rozwoju

Rozdziały 1–4 są wypełnione treścią. Punkty 3.7, 3.8 oraz rozdziały 5–10 zawierają wyłącznie kursywny
znacznik `*TODO.*`, ponieważ odpowiadają etapom, które dopiero będą realizowane — nie dopisuj do nich opisów
planu, metod ani zapowiedzi. Rozwijając dokument, uzupełniaj istniejące rozdziały zamiast dopisywać nowe na
końcu; struktura jest odwzorowaniem instrukcji i nie powinna dryfować. Podział odpowiedzialności znajduje
się w punkcie 4.7, a nie w dodatku.

Dokument opisuje wyłącznie to, co zespół faktycznie wykonał. Wyniki badań, miary i wnioski nigdy nie są
pisane z wyprzedzeniem.

`funkcjonalnosci.md` jest materiałem roboczym i może być starszy od rozdziału 4 dokumentacji. W razie
rozbieżności rozstrzyga `dokumentacja-projektu.md`; aktualizacja pliku roboczego jest opcjonalna.

---

## 6. Podział odpowiedzialności

| Osoba | Funkcjonalności | Obszar |
|---|---|---|
| Natalia Suda | F1 katalog i wyszukiwanie usług, F2 karta statusu i skala przerwy | odkrywanie usług |
| Hubert Tański | F3 powiadomienia i reguły alertów, F4 lokalizacje i grupy usług | docieranie informacji |
| Kacper Tomczyk | F5 zgłaszanie i potwierdzanie awarii, F6 historia przerw i wiarygodność dostawcy | zaufanie i społeczność |
| Jakub Borsuk | F7 komunikacja miejska i alternatywne połączenia, F8 tryb uproszczony i dostępność | mobilność i dostępność |

Każda funkcjonalność ma dokładnie jednego właściciela. Prace nad wspólnym modelem danych (usługa, grupa,
powiadomienie, zgłoszenie) są zespołowe — zmiana w jednej funkcjonalności, która wymusza zmianę w innej,
musi być opisana w obu rozdziałach.

---

## 7. Czego nie robić

Nie zmieniaj zakresu projektu ani wymagań z instrukcji i nie pomijaj żadnego punktu — każdemu punktowi
instrukcji odpowiada rozdział dokumentu.

Nie zmieniaj wariantu projektu na „nowy projekt” i nie proponuj rozwiązań zakładających budowę aplikacji
od zera; punktem wyjścia jest zawsze istniejąca makieta i jej wyniki badań.

Nie usuwaj rozdziałów 5–10 tylko dlatego, że zawierają `TODO`; są one kontraktem wobec kolejnych etapów.

Nie dodawaj funkcji spoza zakresu z rozdziału 4.6 (asystenci domowi, grywalizacja, funkcje społecznościowe,
płatności, automatyczne zgłoszenia do dostawców) bez decyzji zespołu.

Nie twórz plików „na zapas” ani nie zmieniaj nazw istniejących plików bez zgody użytkownika.

---

## 8. Praca z repozytorium

Repozytorium `Projekt` jest osobnym repozytorium git zespołu, gałąź główna `master`. Commity pisz po polsku,
w trybie rozkazującym, z krótkim opisem zakresu (na przykład „Dokumentacja: rozdzial 4 — funkcjonalnosci”).
Nie commituj plików tymczasowych ani eksportów z narzędzi.

Przed rozpoczęciem pracy nad nowym etapem sprawdź, czy w `../wyklady/` nie doszły nowe pliki `wNN.pdf`,
i przeczytaj najnowszy wykład — dokument powinien używać pojęć i metod z wykładów.

Jeżeli czegoś brakuje (dane z badań, decyzja o technologii, wybór person głównych, wyniki testów), zapytaj
użytkownika zamiast uzupełniać lukę własnym domysłem.
