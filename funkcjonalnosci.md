# Funkcjonalności aplikacji — etap 3, pkt 3

- **Wariant projektu:** redesign (rozszerzanie i poprawianie istniejącej aplikacji).
- **Aplikacja źródłowa:** „Informator o przerwach w dostawach usług oraz mediów” — makieta interaktywna (Figma) oraz makiety papierowe i testy moderowane z poprzedniego semestru.
- **Podstawa:** wywiady i wnioski (`materialy/Definicja problemu i wnioski/`), historyjki użytkownika, przypadki użycia oraz wnioski z testów użyteczności makiety cyfrowej.
- **Wymóg:** „Aplikacja powinna zawierać co najmniej 2 główne funkcjonalności dla każdego członka grupy” (`projekt_pdu_redesign.pdf`, pkt 1.4) → 4 osoby × 2 funkcjonalności = **8 funkcjonalności**.

Zasady podziału:

1. Każda funkcjonalność ma jednego właściciela odpowiedzialnego za jej scenariusze badań, warianty interfejsu, implementację i ponowne badania.
2. Każda para funkcjonalności tworzy spójny **obszar odpowiedzialności** (odkrywanie, docieranie informacji, zaufanie, mobilność i dostępność).
3. Każda osoba ma jedną funkcjonalność o priorytecie wysokim i jedną wspierającą — pozwala to równolegle prowadzić prace w etapach 4–9.
4. Zakres każdej funkcjonalności jest zamknięty (sekcja „Zakres”), aby uniknąć rozrostu projektu w etapie implementacji.

---

## Tabela 1. Podział ośmiu funkcjonalności

| ID | Funkcjonalność | Obszar odpowiedzialności | Właściciel | Typ zmiany | Priorytet | Nakład |
|---|---|---|---|---|---|---|
| F1 | Katalog i wyszukiwanie usług | Odkrywanie usług | Natalia Suda | poprawa + rozszerzenie | wysoki | M |
| F2 | Karta statusu i skala przerwy | Odkrywanie usług | Natalia Suda | poprawa + rozszerzenie | wysoki | L |
| F3 | Powiadomienia i reguły alertów | Docieranie informacji | Hubert Tański | poprawa + rozszerzenie | wysoki | L |
| F4 | Lokalizacje i grupy usług | Docieranie informacji | Hubert Tański | poprawa + rozszerzenie | średni | M |
| F5 | Zgłaszanie i potwierdzanie awarii | Zaufanie i społeczność | Kacper Tomczyk | poprawa + rozszerzenie | wysoki | L |
| F6 | Historia przerw i wiarygodność dostawcy | Zaufanie i społeczność | Kacper Tomczyk | rozszerzenie | niski | M |
| F7 | Komunikacja miejska i alternatywne połączenia | Mobilność | Jakub Borsuk | poprawa + rozszerzenie | średni | L |
| F8 | Tryb uproszczony i dostępność | Dostępność (dzieci, seniorzy) | Jakub Borsuk | nowa | wysoki | M |

Nakład: M — średni, L — duży.

---

## F1 — Katalog i wyszukiwanie usług

**Właściciel:** Natalia Suda · **Priorytet:** wysoki · **Nakład:** M

- **Typ zmiany:** poprawa (nazwa i struktura ekranu) + rozszerzenie (tagi, ukrywanie kategorii, usługi własne).
- **Problem:** zakładka „Szukaj” była myląca (wniosek z testów: „użytkownicy nie wiedzieli, co znaczy przycisk szukaj — nazwa zmieniona na usługi”); brakowało filtrowania po kategorii i obsługi mniej popularnych serwisów (USOS, projekty personalne).
- **Zakres:** ekran „Usługi”; wyszukiwanie i kafle kategorii; sekcje „Ostatnio sprawdzane” i „Twoje usługi”; dodawanie własnego linku; ukrywanie kategorii w wynikach.
- **Wymagania:**
  - FR-1.1 Wyszukiwanie po nazwie dostawcy, usłudze i aliasie, z podpowiedziami i tolerancją literówek — kryterium: 4 z 5 zapytań z literówką zwraca właściwą usługę w pierwszych 3 wynikach.
  - FR-1.2 Kafle kategorii (Media, Internet, Komunikacja, Drogi, Usługi online) z możliwością trwałego ukrycia kategorii w wynikach — kryterium: ukrycie „Drogi” usuwa je z listy i z podpowiedzi.
  - FR-1.3 Dodanie usługi do grupy bezpośrednio z wyniku wyszukiwania — kryterium: nie więcej niż 2 interakcje od wyniku do potwierdzenia.
  - FR-1.4 Dodanie usługi spoza katalogu przez URL lub nazwę, z walidacją adresu i statusem „oczekuje na potwierdzenie”.
- **Powiązania:** H-S2, H-O1, H-W1; CU-01, CU-03; ekrany: usługi, szczegóły usługi.
- **Scenariusz badawczy (etap 4):** „Ukryj kategorię Drogi, znajdź Netię i dodaj ją do grupy Uczelnia”.
- **Miara sukcesu:** czas znalezienia usługi ≤ 15 s; skuteczność ≥ 90 %; liczba wejść w martwe ścieżki = 0.

## F2 — Karta statusu i skala przerwy

**Właściciel:** Natalia Suda · **Priorytet:** wysoki · **Nakład:** L

- **Typ zmiany:** poprawa (klik w kafelek otwiera detale) + rozszerzenie (źródło informacji, zasięg, mapa).
- **Problem:** użytkownicy klikali w blok usługi zamiast w przycisk detali („przejście do detali zmienione na kliknięcie na blok”); zgłaszali oczekiwanie pokazania ulic i heatmapy dotkniętych awarią; brakowało rozróżnienia „awaria / konserwacja / problem lokalny”.
- **Zakres:** ekran szczegółów usługi: status, przyczyna, okno czasowe i ETA, postęp napraw, źródło (oficjalne lub zgłoszenia), zasięg przerwy, powiązanie z powiadomieniem i historią.
- **Wymagania:**
  - FR-2.1 Status w trzech stanach (działa / przerwa / problem lokalny) opisany tekstem, ikoną i kolorem — kryterium: możliwy odczyt bez polegania na kolorze.
  - FR-2.2 Dla przerwy: przyczyna, okno „od–do”, ETA, postęp napraw oraz link do oficjalnego komunikatu dostawcy — kryterium: wszystkie pola widoczne bez przewijania na ekranie 360×640 dp.
  - FR-2.3 Skala przerwy: liczba zgłoszeń w okolicy (ostatnia godzina) i mapa/heatmapa ulic wraz z przełącznikiem „tylko moja lokalizacja / cała usługa”.
  - FR-2.4 Odróżnienie przerwy planowanej od nieplanowanej wraz z sugerowanym terminem powiadomienia.
- **Powiązania:** H-D2, H-M1, H-O3, H-O5, H-W2; CU-01 (w tym 3.1 i 3.2); ekrany: szczegóły usługi, mapa.
- **Warianty interfejsu (etap 6):** A — karta pełna (wszystkie dane od razu); B — karta z progresywnym ujawnianiem (nagłówek i sekcje rozwijane).
- **Scenariusz badawczy:** „Sprawdź, czy awaria internetu dotyczy tylko Twojego mieszkania, czy całej okolicy”.
- **Miara sukcesu:** poprawna odpowiedź „lokalna czy powszechna” ≥ 90 %; czas odczytu statusu ≤ 10 s.

## F3 — Powiadomienia i reguły alertów

**Właściciel:** Hubert Tański · **Priorytet:** wysoki · **Nakład:** L

- **Typ zmiany:** poprawa (jawny przełącznik zamiast nieczytelnego dzwonka) + rozszerzenie (reguły, progi, kanały).
- **Problem:** „przycisk powiadomień jest za mało jasny w użyciu — zostaje dodany toggle”, „dzwonek za mało sugestywny”; użytkownicy oczekiwali kontroli nad ilością i rodzajem alertów („bez spamu”), a wywiady wskazywały także na SMS jako kanał.
- **Zakres:** ekran „Powiadomienia” i reguły dla usługi oraz grupy; podgląd przykładowego powiadomienia.
- **Wymagania:**
  - FR-3.1 Widoczny przełącznik powiadomień na karcie usługi i na liście grupy — kryterium: 5/5 użytkowników wskazuje go w teście w ≤ 5 s.
  - FR-3.2 Reguły: tylko planowane / tylko awarie; próg czasu trwania (np. powyżej 30 min); wyprzedzenie dla przerw planowanych (2 h lub 1 dzień); ciche godziny.
  - FR-3.3 Wybór kanału: powiadomienie push, SMS — kryterium: kanał można zmienić bez wchodzenia w ustawienia systemowe.
  - FR-3.4 Zbiorcze sterowanie powiadomieniami dla całej grupy bez usuwania usług.
- **Powiązania:** H-S1, H-S4, H-M2, H-O2, H-W1; CU-05; ekrany: powiadomienia, grupy.
- **Warianty interfejsu (etap 6):** A — lista usług z przełącznikami w miejscu; B — kreator reguł krok po kroku.
- **Scenariusz badawczy:** „Skonfiguruj powiadomienia tak, aby dostawać tylko planowane wyłączenia z jednodniowym wyprzedzeniem”.
- **Miara sukcesu:** poprawnie skonfigurowane reguły ≥ 80 %; subiektywna ocena „spamu” ≤ 2/7; czas konfiguracji ≤ 90 s.

## F4 — Lokalizacje i grupy usług

**Właściciel:** Hubert Tański · **Priorytet:** średni · **Nakład:** M

- **Typ zmiany:** poprawa (zrozumiałość grup) + rozszerzenie (wiele lokalizacji, promień, grupa główna).
- **Problem:** grupy istniały, ale użytkownicy próbowali dodawać usługi obok grupy albo wchodzili w grupę zamiast w usługę; historyjka H-W4 wprost wymaga kilku obszarów (dom, praca, rodzina) bez zmiany ustawień.
- **Zakres:** ekran „Moje grupy”; lokalizacje i promień; grupa główna; zarządzanie grupą (nazwa, lokalizacja, usuwanie, wyłączanie powiadomień).
- **Wymagania:**
  - FR-4.1 Wiele lokalizacji z nazwą własną i promieniem, wskazywanych z mapy lub przez geolokalizację na żądanie (bez śledzenia w tle).
  - FR-4.2 Grupy usług: tworzenie, zmiana nazwy, zmiana lokalizacji, usuwanie, usługa w wielu grupach.
  - FR-4.3 Grupa oznaczona jako główna wyświetlana w „Moich usługach”.
  - FR-4.4 Walidacja przy tworzeniu grupy bez nazwy (obserwacja z testu 8.7) — kryterium: czytelny komunikat i fokus na polu nazwy.
- **Powiązania:** H-M2, H-O2, H-W4; CU-03, CU-06; ekrany: grupy, lokalizacje.
- **Scenariusz badawczy:** „Utwórz grupę Uczelnia z lokalizacją Politechnika i dodaj do niej linię 16106”.
- **Miara sukcesu:** czas utworzenia grupy ≤ 60 s; brak przypadków usługi w niewłaściwej grupie; poprawna odpowiedź na pytanie „czym różni się grupa od lokalizacji” ≥ 80 %.

## F5 — Zgłaszanie i potwierdzanie awarii

**Właściciel:** Kacper Tomczyk · **Priorytet:** wysoki · **Nakład:** L

- **Typ zmiany:** poprawa (widoczne wejście do zgłoszenia) + rozszerzenie („u mnie też”, próg potwierdzenia, status zgłoszenia).
- **Problem:** „użytkownicy mieli problem ze zgłaszaniem awarii — dodany zostaje dodatkowy guzik do zgłaszania awarii”, jeden użytkownik szukał funkcji pod przyciskiem „+”; badani chcieli także wiedzieć, czy problem jest szerszy niż u nich.
- **Zakres:** formularz zgłoszenia, tryb jednego kliknięcia, agregacja zgłoszeń, oznaczenie wiarygodności.
- **Wymagania:**
  - FR-5.1 Wejście do zgłoszenia z trzech miejsc: karty usługi, listy usług (przycisk z etykietą) i powiadomienia.
  - FR-5.2 Formularz na jednym ekranie: usługa (wstępnie wypełniona), „od kiedy” (presety 15/30/60 min), lokalizacja opcjonalna — kryterium: nie więcej niż 3 interakcje do wysłania.
  - FR-5.3 Zgłoszenie „u mnie też nie działa” jednym przyciskiem, bez formularza.
  - FR-5.4 Widoczność liczby zgłoszeń w okolicy oraz progu „potwierdzone przez społeczność”; oznaczenie zgłoszeń niepotwierdzonych.
  - FR-5.5 Limit zgłoszeń i możliwość wycofania zgłoszenia (ochrona przed spamem).
- **Powiązania:** H-M3, H-W3, H-O3; CU-07; ekrany: zgłoś awarię, szczegóły usługi.
- **Warianty interfejsu (etap 6):** A — formularz; B — tryb „najpierw jedno kliknięcie, potem szczegóły”.
- **Scenariusz badawczy:** „Zgłoś, że internet nie działa od 30 minut” oraz „Potwierdź cudze zgłoszenie jednym kliknięciem”.
- **Miara sukcesu:** samodzielne znalezienie funkcji ≥ 90 %; czas zgłoszenia ≤ 20 s; udział zgłoszeń fałszywych ≤ 5 %.

## F6 — Historia przerw i wiarygodność dostawcy

**Właściciel:** Kacper Tomczyk · **Priorytet:** niski · **Nakład:** M

- **Typ zmiany:** rozszerzenie (lista i wykres istniały szczątkowo; dodawane są dowód przerwy i wskaźnik niezawodności).
- **Problem:** H-W5 — historia ma służyć usprawiedliwieniu spóźnienia lub nieobecności oraz ocenie wiarygodności dostawcy; dotychczasowy wykres zgłoszeń był zbyt techniczny i pozbawiony kontekstu.
- **Zakres:** ekran „Historia” dla usługi: lista przerw, trend zgłoszeń, eksport potwierdzenia, wskaźnik niezawodności dostawcy.
- **Wymagania:**
  - FR-6.1 Lista przerw: data, czas trwania, przyczyna, typ (planowana lub nieplanowana), źródło.
  - FR-6.2 Wykres zgłoszeń w zakresach 7 dni, 30 dni i 3 miesiące z nałożeniem oficjalnych przerw.
  - FR-6.3 „Dowód przerwy”: wygenerowanie podsumowania (link lub PDF) z datą, godzinami i nazwą dostawcy.
  - FR-6.4 Wskaźnik niezawodności dostawcy (liczba przerw, średni czas, udział planowanych) i porównanie w obrębie kategorii.
- **Powiązania:** H-S4, H-W5, H-O4; CU-02, CU-04; ekrany: historia, porównanie dostawców.
- **Scenariusz badawczy:** „Znajdź długość przerwy z 12 października i wyeksportuj potwierdzenie”.
- **Miara sukcesu:** czas znalezienia przerwy ≤ 30 s; poprawność wniosku o wiarygodności ≥ 80 %; eksport kończy się sukcesem w 100 % prób.
- **Ryzyko:** brak realnych danych historycznych — w prototypie dane demonstracyjne, wyraźnie oznaczone jako przykładowe.

## F7 — Komunikacja miejska i alternatywne połączenia

**Właściciel:** Jakub Borsuk · **Priorytet:** średni · **Nakład:** L

- **Typ zmiany:** poprawa (status linii) + rozszerzenie (alternatywne połączenie i porównanie czasu).
- **Problem:** H-S3 — student potrzebuje alternatyw dojazdu, aby spełnić obowiązki; dotychczasowy wątek komunikacji kończył się na statusie linii i opóźnieniu.
- **Zakres:** ekran linii i przystanku: status, mapa, opóźnienie, alternatywne połączenie.
- **Wymagania:**
  - FR-7.1 Status linii i przystanku (punktualnie / opóźnienie / objazd / awaria) z mapą przystanków na trasie.
  - FR-7.2 Alternatywne połączenie na wybrany przystanek z porównaniem czasu i liczby przesiadek — kryterium: alternatywa przedstawiona w nie więcej niż 2 krokach od statusu linii.
  - FR-7.3 Dodanie linii do grupy i objęcie jej regułami powiadomień (spójność z F3 i F4).
- **Powiązania:** H-S3; CU-02 (w tym 3.1); ekrany: komunikacja, mapa, alternatywy.
- **Scenariusz badawczy:** „Sprawdź opóźnienie linii 16106 i znajdź alternatywny dojazd na przystanek dworzec główny”.
- **Miara sukcesu:** czas znalezienia alternatywy ≤ 60 s; trafność propozycji oceniona ekspercko ≥ 80 %; zrozumiałość mapy ≥ 5/7.
- **Ryzyko:** brak dostępu do danych rozkładowych — dane demonstracyjne (np. GTFS) i jasne oznaczenie w prototypie.

## F8 — Tryb uproszczony i dostępność

**Właściciel:** Jakub Borsuk · **Priorytet:** wysoki · **Nakład:** M

- **Typ zmiany:** nowa.
- **Problem:** grupą docelową muszą być dzieci i/lub osoby starsze (wymóg etapu 2); persona dziecka deklaruje „nie chcę widzieć niektórych informacji, np. wypadków” oraz prostą nawigację symbolami, a persona dorosłego ma najniższe zaznajomienie z technologią (aplikacje mobilne 5/10).
- **Zakres:** przełączalny tryb uproszczony, filtr treści niepokojących, ustawienia dostępności, słownik pojęć, ekran powitalny.
- **Wymagania:**
  - FR-8.1 Tryb uproszczony: maksymalnie 3 informacje na ekranie, duża typografia, ikony z krótkim tekstem, jedno zadanie na ekran.
  - FR-8.2 Filtr treści niepokojących (wypadki, alerty masowe) — domyślnie włączony dla profilu dziecka, przełączalny przez opiekuna.
  - FR-8.3 Ustawienia dostępności: rozmiar tekstu, kontrast, tryb ciemny, obsługa czytnika ekranu, cele dotykowe ≥ 48 dp.
  - FR-8.4 Słownik pojęć wyjaśniający różnicę „awaria / konserwacja / problem lokalny”, dostępny z każdego statusu.
  - FR-8.5 Ekran powitalny (3 kroki, pomijalny) jako alternatywna forma wsparcia użytkownika wymagana w etapie 6.
- **Powiązania:** H-D1, H-D3, H-O1, H-O2; persony: Dziecko, Dorosły (60+); ekrany: tryb uproszczony, ustawienia, słownik, onboarding.
- **Scenariusz badawczy:** „(dziecko) Sprawdź, czy działa platforma gier” oraz „(senior) Włącz większy tekst i sprawdź status wody”.
- **Miara sukcesu:** wykonanie zadania bez pomocy moderatora ≥ 80 % w grupach 10–14 lat i 60+; SEQ ≥ 6/7; brak błędów wynikających z małych celów dotykowych.
- **Ryzyko:** uproszczenie odbiera informacje oczekiwane przez dorosłych — tryb jest przełączalny, nie globalny.

---

## Tabela 2. Pokrycie person i historyjek

| Persona | F1 | F2 | F3 | F4 | F5 | F6 | F7 | F8 |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Dziecko (10–19) | tak | tak | tak | — | — | — | — | tak |
| Student (19–25) | tak | tak | tak | tak | — | tak | tak | — |
| Młody dorosły (25–35) | tak | tak | tak | tak | tak | tak | tak | — |
| Dorosły (30–60) | tak | tak | tak | tak | tak | tak | tak | tak |

Każda persona ma pokrycie w co najmniej trzech funkcjonalnościach; każda historyjka użytkownika z materiałów (H-D1…H-W5) ma przypisanie do funkcjonalności.

## Tabela 3. Funkcjonalności z dwiema wersjami interfejsu (etap 6)

| Funkcjonalność | Wersja A | Wersja B | Uzasadnienie wyboru |
|---|---|---|---|
| F2 — karta statusu | karta pełna | progresywne ujawnianie | bezpośrednio odpowiada problemowi „klik w kafelek a detale” |
| F3 — powiadomienia | przełączniki w miejscu | kreator reguł | dwa modele mentalne konfiguracji alertów |
| F5 — zgłaszanie awarii | formularz | jedno kliknięcie i szczegóły | sprzeczne oczekiwania: szybkość a dokładność danych |

Trzeci wariant (F7: mapa lub lista przystanków) można dodać, jeśli wystarczy czasu — wymóg mówi o „co najmniej dwóch/trzech” funkcjonalnościach.

## Poza zakresem redesignu

Integracja z asystentami domowymi, grywalizacja i funkcje społecznościowe (dzielenie się), automatyczne zgłaszanie awarii do dostawców, płatności. Są to zachcianki z person, które nie wynikają z potrzeb potwierdzonych w wywiadach; ich włączenie zburzyłoby równy podział pracy.

## Do uzupełnienia

- `../TOPIC.md`: cel projektu w wymaganym formacie („Chcemy rozwiązać problem…”).
- Konkretne cytaty z wywiadów w sekcji „Problem” każdej karty (obecnie wskazane źródło: wnioski z testów makiety cyfrowej).
- Spójność numeracji historyjek (H-D, H-S, H-M, H-O, H-W) i przypadków użycia (CU-01…CU-07) z pozostałymi rozdziałami raportu etapu 3.
