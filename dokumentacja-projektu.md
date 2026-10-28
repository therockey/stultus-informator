# Dokumentacja projektu - redesign aplikacji „ICK Informator”

## 1. Temat i cel projektu

Chcemy rozwiązać problem braku jednego, wiarygodnego źródła informacji o przerwach w dostawach mediów i usług,
dotyczący uczniów i studentów, młodych dorosłych oraz dorosłych, którzy na co dzień korzystają z usług
zewnętrznych dostawców, po to, aby w kilkanaście sekund dowiadywali się oni, że przerwa występuje, jak długo
potrwa, jaki ma zasięg i czy dotyczy tylko ich, oraz aby mogli zaplanować dzień bez przeszukiwania stron
i aplikacji kolejnych dostawców.

Problem potwierdzają wywiady przeprowadzone dwa semestry temu, podczas pierwotnej pracy nad projektem.
Respondenci wskazywali na przerwy w dostawach prądu, wody i internetu, na awarie systemów kolejowych
oraz na planowane wyłączenia ogłaszane kartką na klatce schodowej. Na pytanie o pierwszą reakcję odpowiadali,
że sprawdzają stronę dostawcy, pytają współlokatora, szukają informacji w wyszukiwarce albo po prostu czekają,
licząc, że przerwa sama się skończy. Wniosek z tych wypowiedzi jest jednoznaczny: informacja istnieje, ale jest
rozproszona, publikowana w różnych formach i dociera do użytkownika dopiero wtedy, gdy ten sam zacznie jej szukać.

Drugim źródłem wniosków jest analiza konkurencji wykonana przez pryzmat dziesięciu heurystyk Nielsena dla
serwisów DownDetector oraz IsItDownRightNow. Oba narzędzia dobrze pokazują zbiorczy status usługi, ale nie
oferują personalizacji, nie pozwalają śledzić wielu lokalizacji, nie informują o zasięgu przerwy i posługują się
słownictwem technicznym, niezrozumiałym dla mniej wprawnego odbiorcy. Te mankamenty stały się punktem wyjścia
dla własnego projektu aplikacji mobilnej, w której informacja ma docierać do użytkownika sama, w formie
powiadomienia push, a nie dopiero po jego interwencji.

Projekt realizowany w tym semestrze jest **redesignem**, a nie budową aplikacji od zera. Punktem wyjścia jest
opracowany wcześniej „Informator o przerwach w dostawach usług oraz mediów”: zestaw makiet papierowych
przygotowanych przez potencjalnych użytkowników, interaktywna makieta w Figmie obejmująca wyszukiwanie usług,
szczegóły statusu, powiadomienia, grupy usług, historię awarii i zgłaszanie awarii oraz udokumentowane wyniki
testów moderowanych z pięcioma użytkownikami. Praca w tym semestrze polega na rozszerzeniu funkcjonalności
o obszary, których w makiecie zabrakło lub które wypadły słabo w badaniach, oraz na poprawieniu tych elementów
interfejsu, które w testach sprawiały użytkownikom trudność.

---

## 2. Specyfikacja projektu

### 2.1 Metody zbierania potrzeb i wnioski z badań

Podstawową metodą były **wywiady częściowo ustrukturyzowane** z potencjalnymi użytkownikami. Scenariusz
obejmował dziewięć pytań: o ostatnią sytuację braku usługi, o pierwszą reakcję, o oczekiwany zakres
informowanych usług, o rodzaj informacji potrzebnej w trakcie przerwy, o preferowaną platformę, o liczbę
obserwowanych lokalizacji, o najważniejszą cechę aplikacji oraz o gotowość do zgłaszania awarii i zaufanie do
danych pochodzących od innych użytkowników. Wywiady prowadzono indywidualnie, a odpowiedzi zapisywano w formie
notatek.

*TODO — uzupełnić brakujące wywiady oraz opisy rozmówców.*

Z wywiadów wynikają cztery wnioski, które bezpośrednio kształtują specyfikację. Po pierwsze, użytkownicy chcą
otrzymywać powiadomienia, a nie musieć samodzielnie sprawdzać aplikacji — powiadomienie było najczęściej
wymienianym elementem „bez którego aplikacja nie ma sensu”. Po drugie, oczekują kontroli nad ilością
i rodzajem informacji: chcą zaznaczyć, czy interesuje ich całe miasto, czy tylko własna ulica, i chcą móc
wyłączyć wybrane kategorie, aby uniknąć szumu informacyjnego. Po trzecie, w trakcie przerwy najważniejsze są
czas trwania i szacowany czas naprawy, a przy przerwach planowanych — informacja z wyprzedzeniem; przyczyna
jest istotna dla części rozmówców, obszar przerwy dla większości okazuje się drugorzędny, dopóki nie trzeba
ocenić, czy problem jest powszechny. Po czwarte, użytkownicy chcą wiedzieć, czy zgłoszony problem dotyczy
tylko ich, czy całej okolicy, i są skłonni potwierdzać cudze zgłoszenia jednym kliknięciem, nawet jeśli sami
nie chcą wypełniać formularza.

Uzupełniającym źródłem wiedzy jest **analiza dwóch serwisów konkurencyjnych** przeprowadzona metodą przeglądu
heurystycznego oraz **testy moderowane makiety cyfrowej** z pięcioma użytkownikami i siedmioma zadaniami,
wykonane dwa semestry temu, na etapie projektowania makiety. Testy ujawniły między innymi, że przycisk
powiadomień był zbyt mało czytelny, użytkownicy klikali w blok usługi zamiast w przycisk detali, mieli trudność
ze znalezieniem funkcji zgłaszania awarii, a nazwa zakładki „Szukaj” nie kojarzyła się z listą usług. Wnioski
te stanowią uzasadnienie zakresu poszczególnych funkcjonalności w rozdziale 4 oraz podstawę poprawek interfejsu.

### 2.2 Cel aplikacji

Celem aplikacji jest dostarczenie użytkownikowi w jednym miejscu aktualnej informacji o przerwach w dostawach
mediów i usług oraz o zakłóceniach w działaniu usług cyfrowych i komunikacyjnych, w sposób, który nie wymaga
od niego systematycznego sprawdzania stanu. Aplikacja ma odpowiadać na trzy pytania zadawane w momencie
awarii: czy to dotyczy mnie, jak długo to potrwa i co mogę zrobić w zamian. Odpowiedź na pierwsze pytanie
budowana jest z danych o lokalizacji i zasięgu przerwy, na drugie — z okna czasowego, szacowanego czasu
naprawy i historii podobnych zdarzeń, na trzecie — z propozycji alternatyw dla usług komunikacyjnych oraz
z informacji o usługach, które w danej chwili działają prawidłowo.

Cel drugi, równie istotny, wynika z wariantu redesignu: aplikacja ma być zrozumiała także dla użytkowników
o niskim zaznajomieniu z technologią oraz dla dzieci, których nie interesują techniczne szczegóły, a które
potrzebują krótkiej i spokojnej informacji. Oznacza to ograniczenie liczby elementów na ekranie, rezygnację
z żargonu na rzecz słownika pojęć oraz możliwość ukrycia treści, które mogą niepokoić.

### 2.3 Zadania realizowane za pomocą aplikacji

Zadania użytkownika grupują się w cztery obszary. Pierwszy to **sprawdzenie statusu**: użytkownik wyszukuje
usługę lub dostawcę, wybiera go z listy albo otwiera kartę z ulubionej grupy i odczytuje stan, przyczynę,
okno czasowe i zasięg przerwy, a w razie potrzeby sprawdza, czy awaria dotyczy tylko jego lokalizacji.
Drugi to **docieranie informacji**: użytkownik ustala, o których usługach i w jakich miejscach chce być
informowany, definiuje reguły (na przykład tylko przerwy planowane, z jednodniowym wyprzedzeniem) i odbiera
powiadomienia, dzięki którym nie musi sam sprawdzać stanu usług. Trzeci to **zaufanie do informacji**:
użytkownik zgłasza awarię, potwierdza cudze zgłoszenie, sprawdza liczbę zgłoszeń w okolicy oraz przegląda
historię przerw i wskaźnik niezawodności dostawcy, aby ocenić wiarygodność komunikatu. Czwarty to
**działanie zastępcze**: przy zakłóceniach w komunikacji miejskiej użytkownik otrzymuje propozycję
alternatywnego połączenia i porównanie czasu dojazdu, aby móc zrealizować swoje obowiązki mimo przerwy.

Do zadań obsługiwanych dodatkowo należą: dodanie do katalogu usługi spoza bazy (na przykład strony uczelni
albo projektu personalnego), zarządzanie wieloma lokalizacjami odpowiadającymi domowi, pracy i miejscu
zamieszkania rodziny oraz przeglądanie historii przerw w celu usprawiedliwienia spóźnienia.

### 2.4 Docelowa grupa użytkowników

Grupą docelową są osoby korzystające z usług zewnętrznych dostawców: energii elektrycznej, gazu, wody,
internetu, komunikacji miejskiej, dróg oraz usług cyfrowych. Wspólną cechą tej grupy jest brak czasu
i niechęć do aktywnego monitorowania stanu usług — wszyscy rozmówcy z wywiadów deklarowali, że sprawdzają
informacje dopiero wtedy, gdy coś przestanie działać.

W obrębie grupy wyróżniono cztery profile: dzieci i młodzież w wieku szkolnym, studentów, młodych dorosłych
oraz dorosłych, w tym osoby starsze. Wymaganie instrukcji, aby potencjalnymi użytkownikami były dzieci i/lub
osoby starsze, jest spełnione przez profil dziecka i nastolatka, a dodatkowo aplikacja jest projektowana dla
osób dorosłych o niskim zaznajomieniu z technologią, do których w praktyce należą osoby starsze. Konsekwencją
jest wymaganie dostępności opisane w rozdziale 4 jako funkcjonalność F8, a także rezygnacja z gęstych ekranów
analitycznych na rzecz krótkich komunikatów.

### 2.5 Technologia implementacji

*TODO.*

---

## 3. Kontekst i przypadki użycia

Rozdział opisuje, kim są użytkownicy, w jakim środowisku będą pracować z aplikacją, jakie zadania realizują
oraz jakie czynniki sprzyjają interakcji i jakie jej zagrażają.

### 3.1 Cechy użytkowników

Cechą wspólną wszystkich profili jest ograniczona uwaga poświęcana usługom dostawców: użytkownik sięga po
informację dopiero pod wpływem zdarzenia, najczęściej w sytuacji, gdy brakuje prądu, wody, internetu albo
połączenia. Wiedza techniczna jest bardzo zróżnicowana — od uczniów biegle poruszających się w aplikacjach
mobilnych po dorosłych, którzy deklarują przeciętne lub niskie zaznajomienie z oprogramowaniem. Wszyscy
badani oczekują informacji krótkiej i jednoznacznej, a nadmiar szczegółów technicznych uznają za obciążenie.
Istotną cechą jest też mobilność: część użytkowników przebywa w ciągu dnia w kilku miejscach (dom, uczelnia
lub praca, miejsce zamieszkania rodziny), dlatego informacja przypisana wyłącznie do bieżącej lokalizacji jest
niewystarczająca.

### 3.2 Elementy i aspekty środowiska użycia

Środowisko użycia jest zmienne i często nieprzyjazne. Przerwa w dostawie internetu oznacza, że aplikacja
działa w warunkach ograniczonej łączności, co nakłada wymaganie pracy na danych ostatnio pobranych i czytelnego
oznaczenia informacji nieaktualnej. Przerwa w dostawie prądu wiąże się z kolei z rozładowanym telefonem,
więc czas do informacji musi być krótki. Użytkownik sprawdza status w pośpiechu — w drodze, przed wyjściem
z domu, w trakcie dojazdu — często jedną ręką i w złych warunkach oświetleniowych, co uzasadnia duże cele
dotykowe i wysoki kontrast. Część sytuacji ma charakter społeczny: informacja bywa potrzebna do usprawiedliwienia
spóźnienia wobec wykładowcy lub pracodawcy, co czyni wiarygodność i możliwość udokumentowania przerwy
osobnym wymaganiem. W tle występuje też kontekst emocjonalny: użytkownicy, zwłaszcza dzieci, deklarują
niechęć do treści alarmujących, dlatego środowisko użycia obejmuje także potrzebę ograniczenia bodźców
niepokojących.

### 3.3 Persony

W badaniach wyróżniono cztery profile użytkowników:
- **Dziecko**: (10–19 lat, uczeń, miasto lub wieś) spędza
wolny czas w internecie i w grach, wysoko ocenia własną biegłość w aplikacjach mobilnych, ale nisko w obsłudze
oprogramowania. Chce sprawdzać informacje szybko i bez nudy, chce znać czas trwania i powód przerwy, nie chce
widzieć treści, które mogą je zaniepokoić, i oczekuje prostej nawigacji opartej na symbolach. 
- **Student**: (19–25 lat, akademik lub wynajmowane mieszkanie, praca na pół etatu) przebywa poza domem w różnych porach
i potrzebuje informacji o kilku miejscach jednocześnie, wczesnych powiadomień o przerwach planowanych,
dostępu do mniej popularnych usług, takich jak strona uczelni, oraz alternatyw dla komunikacji miejskiej.
- **Młody dorosły**: (25–35 lat, wynajmowane mieszkanie w mieście, praca projektowa) oczekuje informacji
natychmiastowej i dokładnej, personalizacji powiadomień, przejrzystości przyczyn i czasu przywrócenia usług
oraz potwierdzenia społecznościowego; ceni szybkość i prostotę, a obawia się dezinformacji. 
- **Dorosły**:(30–60 lat, duże miasto, praca w marketingu cyfrowym) chce jednego miejsca, w którym sprawdzi status,
powiadomień bez spamu, rozróżnienia problemu lokalnego od powszechnego, potwierdzenia, że informacja pochodzi
z oficjalnego źródła, oraz wcześniejszych informacji o wyłączeniach planowanych.

### 3.4 Historyjki użytkownika

Historyjki spisano dla każdej persony oraz dla potrzeb wspólnych. Dziecko formułuje trzy oczekiwania: chce
sprawdzać informacje bez spędzania w aplikacji długiego czasu, chce wiedzieć, jak długo potrwa przerwa i z jakiej
wynika przyczyny, oraz nie chce widzieć informacji, które mogłyby je zmartwić. Student chce otrzymywać
powiadomienia z wyprzedzeniem, aby zaplanować dzień, chce mieć dostęp do mniej popularnych stron, takich jak
strona uczelni czy projekty personalne, chce widzieć alternatywy dla usług, z których nie może skorzystać,
oraz chce móc wyłączyć powiadomienia o wybranych usługach, aby nie otrzymywać spamu.

Młody dorosły chce wiedzieć, czy przerwa wynika z awarii, konserwacji czy problemu lokalnego, aby szybko
zmienić plan dnia lub zgłosić usterkę; chce ustawić, które usługi i obszary go interesują; chce też jednym
przyciskiem potwierdzić cudze zgłoszenie, aby wesprzeć społeczność i zwiększyć dokładność raportu. Dorosły
chce mieć jedno miejsce do sprawdzania statusu usług zamiast kilku stron i aplikacji, chce powiadomień
ograniczonych do własnych lokalizacji i usług, chce rozróżnić przerwę dotyczącą tylko jego mieszkania od
przerwy w całej okolicy, chce mieć pewność, że informacje pochodzą z oficjalnych i sprawdzonych źródeł oraz
chce wiedzieć o planowanych wyłączeniach z wyprzedzeniem.

Potrzeby wspólne ujęto w pięciu historyjkach: natychmiastowe powiadomienia push o przerwach, pełniejsza
informacja o usłudze (czas trwania i powód), widoczna liczba osób zgłaszających ten sam problem w pobliżu,
możliwość śledzenia przerw w kilku wybranych obszarach bez zmiany ustawień oraz dostęp do historii przerw
i napraw, służącej zarówno usprawiedliwieniu spóźnienia, jak i ocenie wiarygodności dostawcy.

### 3.5 Przypadki użycia

Przypadki użycia uporządkowano w cztery grupy i oznaczono identyfikatorami CU-01 do CU-07, używanymi dalej
w całym dokumencie.

- **Sprawdzanie awarii** obejmuje trzy przypadki. CU-01 to sprawdzenie usługi lub serwisu: użytkownik otwiera
aplikację, wpisuje nazwę albo wybiera usługę z listy, a system zwraca status (brak problemów, awaria, przerwa
techniczna, inny problem) oraz liczbę zgłoszeń z ostatniej godziny; gdy status jest inny niż „brak problemów”,
system podaje szacowany czas powrotu do sprawności i oficjalne stanowisko dostawcy, a przy ustalonej lokalizacji
porównuje stan ogólny ze stanem w tym miejscu. CU-02 to sprawdzenie usług publicznych, na przykład linii
komunikacji miejskiej: użytkownik wpisuje numer linii lub nazwę usługi, a system zwraca status, opóźnienie
i mapę przystanków, a po wskazaniu przystanku proponuje alternatywny dojazd wraz z porównaniem czasu. CU-03
to sprawdzenie „swoich” usług: użytkownik wchodzi w zakładkę z grupą oznaczoną jako główna i widzi zbiorczy
status usług w tej grupie.

- **Sprawdzanie historii awarii** (CU-04, aktorzy: młody dorosły i student) polega na wybraniu usługi i wejściu
w zakładkę historii, gdzie system zwraca listę znanych przerw z czasem trwania i przyczyną oraz wykres liczby
zgłoszeń w okresie ostatniego tygodnia, miesiąca lub trzech miesięcy.

- **Ustalanie powiadomień** obejmuje dwa przypadki. CU-05 to konfiguracja powiadomień: użytkownik wchodzi
w zakładkę powiadomień, wybiera usługę, zaznacza chęć otrzymywania powiadomień i przypisuje usługę do grupy.
CU-06 to zarządzanie grupą jako scenariusz alternatywny: użytkownik wchodzi w widok grup, wybiera grupę
i może wyłączyć powiadomienia wszystkich usług w grupie, zmienić jej lokalizację, usunąć grupę lub usunąć
z niej pojedynczą usługę.

- **Zgłaszanie awarii** (CU-07, aktorzy: dorosły i młody dorosły) polega na wypełnieniu formularza: użytkownik
wyszukuje usługę, podaje czas trwania awarii w formie przedziału („od 30 minut”, „od godziny”), opcjonalnie
dodaje lokalizację i wysyła zgłoszenie, które trafia do puli zgłoszeń danej usługi.

### 3.6 Scenariusze

Scenariusze opisują przebieg pracy użytkownika w kontekście, a nie w izolacji od niego. Scenariusz studenta
rozpoczyna się rano, gdy w akademiku nie działa internet: student otwiera aplikację, widzi grupę „Uczelnia”
i status usługi, dowiaduje się, że przerwa jest planowana i potrwa do godziny czternastej, po czym sprawdza,
czy zajęcia odbywają się w trybie zdalnym. Scenariusz młodego dorosłego dotyczy awarii nieplanowanej: po
powrocie do mieszkania okazuje się, że nie działa prąd, użytkownik potwierdza jednym kliknięciem zgłoszenie
sąsiada, widzi, że w promieniu kilometra zgłosiło je kilkadziesiąt osób, i uznaje, że nie ma sensu zgłaszać
usterki indywidualnie. Scenariusz dorosłego obejmuje planowane wyłączenie wody, o którym aplikacja informuje
dzień wcześniej, co pozwala przygotować zapas wody i przełożyć pranie. Scenariusz dziecka dotyczy platformy
gier: użytkownik sprawdza, czy awaria dotyczy tylko jego urządzenia, a następnie odkrywa w słowniku pojęć,
czym różni się awaria od konserwacji, i nie napotyka przy tym informacji o wypadkach.

Scenariusze te są podstawą scenariuszy badań użyteczności.

### 3.7 SWOT

*TODO.*

### 3.8 QFD

*TODO.*

---

## 4. Funkcjonalności aplikacji

Instrukcja wymaga, aby aplikacja zawierała co najmniej dwie główne funkcjonalności dla każdego członka grupy.
Zespół liczy cztery osoby, dlatego wyodrębniono **osiem funkcjonalności**, po dwie dla każdej osoby. Podział
nie jest przypadkowy: funkcjonalności łączą się w pary tworzące spójne obszary odpowiedzialności, dzięki czemu
każdy członek zespołu prowadzi własny wątek od scenariusza badań, przez warianty interfejsu, po ponowne badania.

Wybór zakresu opiera się na trzech przesłankach: historyjkach użytkownika z rozdziału 3.4, wnioskach z wywiadów
opisanych w rozdziale 2.1 oraz wynikach testów makiety cyfrowej, które wskazały elementy wymagające poprawy.
Każda funkcjonalność ma zamknięty zakres, aby w etapie implementacji nie rozrastała się poza założenia.

### 4.1 Obszar: odkrywanie usług

**F1 — Katalog i wyszukiwanie usług.** 
- Osoba odpowiedzialna: Natalia Suda

Funkcjonalność obejmuje ekran „Usługi”, na którym użytkownik wyszukuje dostawcę lub usługę, przegląda kafle
kategorii (Media, Internet, Komunikacja, Drogi, Usługi online) i widzi sekcje „Ostatnio sprawdzane” oraz
„Twoje usługi”. Zmiana polega na poprawie tego, co w testach okazało się nieczytelne — nazwa zakładki
„Szukaj” zostaje zastąpiona nazwą „Usługi”, a wyniki wyszukiwania pozwalają od razu dodać usługę do grupy —
oraz na rozszerzeniu zakresu o ukrywanie wybranych kategorii, wyszukiwanie odporne na literówki i dodawanie
usług spoza katalogu przez adres URL. Rozszerzenie odpowiada historyjkom o dostępie do mniej popularnych
stron, takich jak strona uczelni czy projekt personalny, oraz potrzebie ograniczenia treści nieistotnych.
Kryterium akceptacji zakłada znalezienie usługi w czasie do piętnastu sekund i skuteczność na poziomie
dziewięćdziesięciu procent.

**F2 — Karta statusu i skala przerwy.** 
- Osoba odpowiedzialna: Natalia Suda

Funkcjonalność obejmuje ekran szczegółów usługi: status w jednym z trzech stanów (działa, przerwa, problem
lokalny) opisany jednocześnie tekstem, ikoną i kolorem, przyczynę przerwy, okno czasowe, szacowany czas
naprawy, postęp prac, informację o źródle danych oraz zasięg przerwy. Zmiana naprawia problem ujawniony
w testach, w których użytkownicy klikali w blok usługi zamiast w przycisk detali — teraz kliknięcie w blok
otwiera szczegóły. Rozszerzeniem jest skala przerwy: liczba zgłoszeń w okolicy z ostatniej godziny oraz
mapa z zaznaczonymi ulicami objętymi awarią, z przełącznikiem między widokiem lokalnym a widokiem całej
usługi. To rozszerzenie odpowiada wprost na oczekiwanie zgłoszone przez jednego z uczestników testów oraz
na historyjki o rozróżnieniu problemu lokalnego od powszechnego.

### 4.2 Obszar: docieranie informacji

**F3 — Powiadomienia i reguły alertów.** 
- Osoba odpowiedzialna: Hubert Tański

Funkcjonalność obejmuje konfigurację powiadomień dla usług i grup oraz reguły określające, kiedy
powiadomienie ma zostać wysłane: tylko przerwy planowane lub tylko awarie, próg czasu trwania, wyprzedzenie
dla przerw planowanych (dwie godziny lub jeden dzień) i ciche godziny. Użytkownik wybiera też kanał —
powiadomienie push lub SMS. Zmiana dotyczy czytelności: w miejsce mało sugestywnego dzwonka pojawia się
jawny przełącznik widoczny na karcie usługi i na liście grupy, a powiadomieniami można sterować zbiorczo dla
całej grupy bez usuwania z niej usług. Rozszerzenie wynika z historyjek o unikaniu spamu i o powiadomieniach
z wyprzedzeniem; kryterium akceptacji zakłada, że wszyscy uczestnicy testu wskażą przełącznik w ciągu pięciu
sekund, a konfiguracja reguły zajmie nie więcej niż dziewięćdziesiąt sekund.

**F4 — Lokalizacje i grupy usług.** 
- Osoba odpowiedzialna: Hubert Tański

Funkcjonalność obejmuje ekran „Moje grupy” wraz z zarządzaniem lokalizacjami. Użytkownik tworzy grupy o
własnych nazwach (na przykład „Dom”, „Uczelnia”, „Rodzina”), przypisuje im lokalizacje i promień, oznacza jedną
grupę jako główną oraz zmienia nazwę lub lokalizację, usuwa grupę, a także wyłącza powiadomienia całej grupy.
Lokalizacje są wskazywane z mapy albo przez jednorazowe użycie geolokalizacji, bez śledzenia w tle. Zmiana
porządkuje to, co w testach było niejasne: użytkownicy próbowali dodawać usługi obok grupy albo wchodzili
w grupę zamiast w usługę, a przy tworzeniu grupy bez nazwy nie otrzymywali czytelnego komunikatu. Rozszerzenie
o wiele lokalizacji odpowiada historyjce osoby mieszkającej w jednym miejscu, pracującej w drugim i odwiedzającej
rodzinę w trzecim.

### 4.3 Obszar: zaufanie i społeczność

**F5 — Zgłaszanie i potwierdzanie awarii.** 
- Osoba odpowiedzialna: Kacper Tomczyk

Funkcjonalność obejmuje formularz zgłoszenia dostępny na jednym ekranie — z usługą wstępnie wypełnioną,
presetami czasu trwania (piętnaście, trzydzieści, sześćdziesiąt minut) i opcjonalną lokalizacją — a także tryb
potwierdzenia cudzego zgłoszenia jednym przyciskiem „u mnie też nie działa”, bez wypełniania formularza.
Do funkcjonalności należy też widoczność liczby zgłoszeń w okolicy, próg uznania zgłoszenia za potwierdzone
przez społeczność, oznaczenie zgłoszeń niepotwierdzonych oraz limit i możliwość wycofania własnego zgłoszenia.
Zmiana dotyczy dostępności funkcji: w testach użytkownicy nie potrafili jej znaleźć, dlatego wejście do
zgłoszenia pojawia się w trzech miejscach — na karcie usługi, na liście usług i w powiadomieniu. Kryterium
akceptacji zakłada samodzielne znalezienie funkcji przez dziewięćdziesiąt procent uczestników i czas zgłoszenia
do dwudziestu sekund.

**F6 — Historia przerw i wiarygodność dostawcy.** 
 - Osoba odpowiedzialna: Kacper Tomczyk

Funkcjonalność rozwija ekran historii awarii, który w makiecie istniał w szczątkowej formie. Użytkownik widzi
listę przerw z datą, czasem trwania, przyczyną, typem (planowana lub nieplanowana) i źródłem, wykres zgłoszeń
w zakresach siedmiu dni, trzydziestu dni i trzech miesięcy z nałożonymi oficjalnymi przerwami, a także
wskaźnik niezawodności dostawcy obejmujący liczbę przerw, średni czas trwania i udział przerw planowanych.
Nowym elementem jest „dowód przerwy” — generowane podsumowanie z datą, godzinami i nazwą dostawcy, możliwe
do przedstawienia wykładowcy lub pracodawcy. Rozszerzenie wynika z historyjki o usprawiedliwieniu spóźnienia
i z potrzeby oceny wiarygodności dostawcy; w prototypie dane historyczne są demonstracyjne i oznaczone jako
przykładowe.

### 4.4 Obszar: mobilność i dostępność

**F7 — Komunikacja miejska i alternatywne połączenia.** 
- Osoba odpowiedzialna: Jakub Borsuk

Funkcjonalność obejmuje ekran linii i przystanku: status (punktualnie, opóźnienie, objazd, awaria), mapę
przystanków na trasie oraz — co stanowi właściwe rozszerzenie — propozycję alternatywnego połączenia na wybrany
przystanek wraz z porównaniem czasu i liczby przesiadek. Alternatywa jest dostępna w najwyżej dwóch krokach
od statusu linii. Linię można dodać do grupy i objąć regułami powiadomień, co spina tę funkcjonalność z F3 i F4.
Rozszerzenie odpowiada historyjce studenta, który potrzebuje alternatywy, aby wywiązać się z obowiązków;
dotychczasowy wątek komunikacji kończył się na statusie i opóźnieniu.

**F8 — Tryb uproszczony i dostępność.** 
- Osoba odpowiedzialna: Jakub Borsuk

Funkcjonalność jest nowa i wynika z wymagania, aby użytkownikami były dzieci i/lub osoby starsze. Obejmuje
przełączalny tryb uproszczony z maksymalnie trzema informacjami na ekranie, dużą typografią i ikonami
opatrzonymi krótkim tekstem, filtr treści niepokojących (wypadki, alerty masowe) domyślnie włączony dla
profilu dziecka i przełączalny przez opiekuna, ustawienia dostępności (rozmiar tekstu, kontrast, tryb ciemny,
obsługa czytnika ekranu, cele dotykowe o rozmiarze co najmniej 48 dp) oraz słownik pojęć wyjaśniający różnicę
między awarią, konserwacją i problemem lokalnym. W ramach tej funkcjonalności powstaje również ekran
powitalny z trzema krokami, pełniący rolę alternatywnej formy wsparcia użytkownika.
Tryb jest przełączalny, a nie globalny, aby nie odbierać informacji użytkownikom oczekującym szczegółów.

### 4.5 Pokrycie person i historyjek

Wszystkie historyjki z rozdziału 3.4 mają przypisanie do funkcjonalności. Dziecko korzysta z F1, F2, F3 i F8;
student z F1, F2, F3, F4, F6 i F7; młody dorosły z wszystkich funkcjonalności poza F8; dorosły z wszystkich
ośmiu. Każda persona ma zatem pokrycie w co najmniej trzech funkcjonalnościach, a żadna funkcjonalność nie
istnieje bez uzasadnienia w historyjce lub w wyniku testów.

### 4.6 Zakres poza redesignem

Poza zakresem pozostają funkcje, które pojawiły się w profilach person jako zachcianki, ale nie wynikają
z potrzeb potwierdzonych w wywiadach: integracja z asystentami domowymi, grywalizacja i funkcje społecznościowe
polegające na dzieleniu się problemami, automatyczne zgłaszanie awarii bezpośrednio do dostawców oraz płatności.
Ich włączenie zburzyłoby równy podział pracy i rozmyłoby cel aplikacji, jakim jest szybka, wiarygodna informacja
o przerwie.

---

## 5. Scenariusze badań

*TODO.*

---

## 6. Badania użyteczności

*TODO.*

---

## 7. Poprawa interfejsu

*TODO.*

---

## 8. Ponowne badania z użytkownikami

*TODO.*

---

## 9. Ocena użyteczności przez użytkowników

*TODO.*

---
