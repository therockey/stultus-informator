# **Dokumentacja projektu - redesign aplikacji „ICK Informator”**

## 1. Temat i cel projektu

Chcemy rozwiązać problem braku jednego, wiarygodnego źródła informacji o przerwach w dostawach mediów i usług, dotyczący uczniów i studentów, młodych dorosłych oraz dorosłych, którzy na co dzień korzystają z usług zewnętrznych dostawców, po to, aby w kilkanaście sekund dowiadywali się oni, że przerwa występuje, jak długo potrwa, jaki ma zasięg i czy dotyczy tylko ich, oraz aby mogli zaplanować dzień bez przeszukiwania stron i aplikacji kolejnych dostawców.

Problem potwierdzają wywiady przeprowadzone dwa semestry temu, podczas pierwotnej pracy nad projektem. Respondenci wskazywali na przerwy w dostawach prądu, wody i internetu, na awarie systemów kolejowych oraz na planowane wyłączenia ogłaszane kartką na klatce schodowej. Na pytanie o pierwszą reakcję odpowiadali, że sprawdzają stronę dostawcy, pytają współlokatora, szukają informacji w wyszukiwarce albo po prostu czekają, licząc, że przerwa sama się skończy. Wniosek z tych wypowiedzi jest jednoznaczny: informacja istnieje, ale jest rozproszona, publikowana w różnych formach i dociera do użytkownika dopiero wtedy, gdy ten sam zacznie jej szukać.

Drugim źródłem wniosków jest analiza konkurencji wykonana przez pryzmat dziesięciu heurystyk Nielsena dla serwisów DownDetector oraz IsItDownRightNow. Oba narzędzia dobrze pokazują zbiorczy status usługi, ale nie oferują personalizacji, nie pozwalają śledzić wielu lokalizacji, nie informują o zasięgu przerwy i posługują się słownictwem technicznym, niezrozumiałym dla mniej wprawnego odbiorcy. Te mankamenty stały się punktem wyjścia dla własnego projektu aplikacji mobilnej, w której informacja ma docierać do użytkownika sama, w formie powiadomienia push, a nie dopiero po jego interwencji.

Projekt realizowany w tym semestrze jest **redesignem**, a nie budową aplikacji od zera. Punktem wyjścia jest opracowany wcześniej „Informator o przerwach w dostawach usług oraz mediów”: zestaw makiet papierowych przygotowanych przez potencjalnych użytkowników, interaktywna makieta w Figmie obejmująca wyszukiwanie usług, szczegóły statusu, powiadomienia, grupy usług, historię awarii i zgłaszanie awarii oraz udokumentowane wyniki testów moderowanych z pięcioma użytkownikami. Praca w tym semestrze polega na rozszerzeniu funkcjonalności o obszary, których w makiecie zabrakło lub które wypadły słabo w badaniach, oraz na poprawieniu tych elementów interfejsu, które w testach sprawiały użytkownikom trudność.

## 2. Specyfikacja projektu

### 2.1 Metody zbierania potrzeb i wnioski z badań

Podstawową metodą były **wywiady częściowo ustrukturyzowane** z potencjalnymi użytkownikami. Badania prowadzono w dwóch turach. Tura archiwalna zrealizowana została dwa semestry temu, na wcześniejszym kursie, i objęła sześć osób; jej wynikiem są notatki z odpowiedziami przypisanymi do pytań, bez metryczek rozmówców. Tura bieżąca jest prowadzona w tym semestrze, a jej uczestnicy są scharakteryzowani w tabeli zamieszczonej dalej w tym punkcie. Obie tury wykorzystują ten sam scenariusz, obejmujący dziewięć pytań: o ostatnią sytuację braku usługi, o pierwszą reakcję, o oczekiwany zakres informowanych usług, o rodzaj informacji potrzebnej w trakcie przerwy, o preferowaną platformę, o liczbę obserwowanych lokalizacji, o najważniejszą cechę aplikacji oraz o gotowość do zgłaszania awarii i zaufanie do danych pochodzących od innych użytkowników. Wywiady prowadzono indywidualnie, a odpowiedzi zapisywano w formie notatek.

*TODO - uzupełnić metryki rozmówców tury archiwalnej, w tym jawny podział na osoby technicznie zaawansowane i „laików”, oraz opisać brakujące wywiady tury bieżącej. Notatki archiwalne zawierają wyłącznie odpowiedzi, bez danych o rozmówcach.*

Tura archiwalna przyniosła odpowiedzi sześciu osób. Najczęściej opisywaną sytuacją był brak prądu - trzy wskazania, w tym jedno wyłączenie nieplanowane i bez uprzedzenia oraz jedno w hotelu - a następnie awaria internetu, wskazana dwa razy; po jednym razie wymieniono niedziałający system sprzedaży biletów PKP oraz planowane odcięcie wody. Tylko ta ostatnia sytuacja była zapowiedziana z wyprzedzeniem, i to kartką na klatce schodowej, co oznacza, że w pięciu z sześciu przypadków informacja nie dotarła do użytkownika przed zdarzeniem. Pierwsza reakcja była za każdym razem inna: sprawdzenie strony dostawcy, zmiana na rozwiązanie alternatywne bez szukania informacji, próba uzyskania informacji od innego człowieka, pytanie współlokatora sprawdzającego stronę dostawcy, odłożone sprawdzenie stanu dopiero po przeciągnięciu się przerwy oraz szukanie w wyszukiwarce doniesień o awarii. Żadna z odpowiedzi nie wskazywała jednego miejsca, w którym można sprawdzić stan wszystkich swoich usług, a połowa opisanych reakcji opierała się na pośredniku - innym człowieku albo wyszukiwarce - zamiast na źródle dostawcy.

Oczekiwany zakres informacji obejmował przede wszystkim media podstawowe, czyli prąd, gaz, wodę i internet, wymienione w czterech z sześciu odpowiedzi, a obok nich komunikację miejską wraz z zamknięciami i awariami, zamknięte drogi, pogodę i alerty RCB. Dwie osoby rozszerzyły ten zakres na usługi cyfrowe, wskazując strony uczelniane oraz serwisy biznesowe jako te, o których chcą wiedzieć najwcześniej, i jedna z nich zaproponowała możliwość dodania własnego adresu. Szczegółowość w obrębie komunikacji miejskiej określono tylko w dwóch odpowiedziach: jako obserwację najczęściej używanych miejsc oraz jako wybór konkretnych linii i przystanków. Pozostałe osoby tego wątku nie rozwinęły.

W pytaniu o treść komunikatu w trakcie przerwy czas trwania i szacowany czas naprawy wymienili wszyscy rozmówcy. Przyczyna pojawiła się w dwóch odpowiedziach, jedna osoba uznała ją za nieistotną, a jedna pytała w tym miejscu o charakter zdarzenia, czyli o rozróżnienie awarii i przerwy planowanej. Zasięg przerwy dwie osoby wprost określiły jako mało ważny i zastrzegły, że zaczyna mieć znaczenie tylko wtedy, gdy informacja dociera z wyprzedzeniem; jedna osoba oczekiwała ponadto informowania o postępach naprawy.

Aplikację mobilną wskazało pięć z sześciu osób, przy czym w dwóch odpowiedziach obok aplikacji pojawił się SMS, a jedna osoba uzasadniła wybór tym, że stronę internetową trzeba odwiedzać celowo. Potrzebę obserwowania wielu miejsc zgłosiło pięć osób, w tym dwie chciały połączyć bieżącą lokalizację z miejscami dodanymi ręcznie, a jedna uznała informację o lokalizacji za nieistotną. Na pytanie o element niezbędny odpowiedziały cztery osoby i wszystkie wskazały powiadomienia, jedna z nich dodając warunek, aby nie były nadmiarowe i aby można było wybrać ich kategorie.

Stosunek do treści pochodzących od innych użytkowników był przeważnie pozytywny: trzy odpowiedzi deklarowały zaufanie lub gotowość korzystania z takiej funkcji, jedna uzależniała je od dużej liczby zgłoszeń i od rozróżnienia sposobu ich potwierdzania, a jedna nie zgłaszała takiej potrzeby. Najbardziej użyteczny powód pojawił się w odpowiedzi, w której wartość funkcji polega nie na samym raportowaniu, lecz na możliwości odróżnienia awarii powszechnej od usterki dotyczącej jednego mieszkania.

Pełne zestawienie odpowiedzi z tury archiwalnej zawiera poniższa tabela. Numer osoby oznacza pozycję odpowiedzi w notatkach, a nie tożsamość rozmówcy, ponieważ notatki nie zawierają metryczek.

| Pytanie | Osoba | Odpowiedź |
| :---- | :---- | :---- |
| 1. Kiedy ostatnio zabrakło usługi, która była potrzebna? | 1 | wrzesień - brak prądu i internetu |
|  | 2 | przedwczoraj, godz. 22:00 - awaria systemu PKP |
|  | 3 | wakacje - brak prądu w hotelu |
|  | 4 | miesiąc temu - awaria internetu |
|  | 5 | miesiąc temu - nieplanowane wyłączenie prądu, bez uprzedzenia |
|  | 6 | pół roku temu - planowane odcięcie wody, zapowiedziane kartką na klatce schodowej |
| 2. Co zwykle robisz jako pierwszą czynność w przypadku braku medium lub usługi? | 1 | sprawdzenie strony dostawcy |
|  | 2 | nic - zmiana na rozwiązanie alternatywne |
|  | 3 | próba uzyskania informacji od innego człowieka |
|  | 4 | pytanie współlokatora, który sprawdza stronę dostawcy |
|  | 5 | chwilowe czekanie, sprawdzenie dopiero gdy przerwa się przeciąga |
|  | 6 | szukanie w wyszukiwarce informacji o awarii lub wyłączeniu |
| 3. Jakie usługi powinny być objęte informacją? | 1 | usługi podstawowe, zamknięte drogi, pogoda, alerty RCB |
|  | 2 | usługi podstawowe, komunikacja publiczna (zamknięcia, awarie) |
|  | 3 | usługi podstawowe |
|  | 4 | usługi podstawowe |
|  | 5 | strony i media, przede wszystkim strony niezbędne, na przykład USOS lub serwisy biznesowe |
|  | 6 | media oraz strony, z możliwością podania własnego adresu |
| 4. Jaki zakres informacji cię interesuje, na przykład w przypadku komunikacji miejskiej? | 1 | najczęściej używane miejsca |
|  | 2 | możliwość zaznaczenia opcji, takich jak linie i przystanki |
|  | - | *Pozostałe osoby tego pytania nie omówiły.* |
| 5. Jakie informacje chcesz otrzymywać w przypadku przerwy w dostawie? | 1 | jak długo potrwa przerwa, postępy naprawy |
|  | 2 | przyczyna, szacowany czas zakończenia |
|  | 3 | przyczyna, szacowany czas zakończenia |
|  | 4 | od kiedy trwa, szacowany czas zakończenia, czy przerwa jest planowana |
|  | 5 | najważniejszy czas trwania; zasięg mało istotny poza przypadkami zapowiedzianymi z wyprzedzeniem; przyczyna nieistotna |
|  | 6 | najważniejsze okno czasowe; przyczyna również istotna; zasięg mało istotny |
| 6. Na jakiej platformie chciałbyś, aby system był dostępny? | 1 | SMS, aplikacja mobilna |
|  | 2 | aplikacja z powiadomieniami push |
|  | 3 | aplikacja mobilna |
|  | 4 | SMS i powiadomienia push |
|  | 5 | aplikacja mobilna, ponieważ stronę internetową trzeba odwiedzać celowo |
|  | 6 | aplikacja mobilna |
| 7. Czy chcesz otrzymywać powiadomienia tylko o swojej lokalizacji, czy też o innych miejscach? | 1 | tak, wybrane lokalizacje |
|  | 2 | kilka lokalizacji wybranych ręcznie |
|  | 3 | własna lokalizacja oraz dodatkowe interesujące miejsca |
|  | 4 | nie ma to znaczenia |
|  | 5 | określony obszar i kilka lokalizacji, pozostałe są nieistotne |
|  | 6 | wystarczy własna lokalizacja, ale przydałaby się możliwość ręcznego dodawania kolejnych |
| 8. Co byłoby najważniejsze w takiej aplikacji? Czego nie może zabraknąć? | 1 | powiadomienia |
|  | 2 | powiadomienia |
|  | 3 | możliwość wyboru powiadomień bez nadmiaru, powiadomienia |
|  | 4 | powiadomienia |
|  | - | *Pozostałe dwie osoby tego pytania nie omówiły.* |
| 9. Czy chcesz mieć możliwość podawania informacji? Czy wierzysz informacjom podawanym przez innych użytkowników? | 1 | tak, ufa użytkownikom |
|  | 2 | tak, pod warunkiem że zgłoszeń będzie dużo, wraz z rozróżnieniem sposobu ich potwierdzania |
|  | 3 | nie, nie potrzebuje takich informacji |
|  | 4 | tak |
|  | 5 | przy awarii lub przerwie nieplanowanej warto wiedzieć, czy problem jest szerszy, czy dotyczy tylko tej osoby |
|  | 6 | sam nie chciałby zgłaszać, ale funkcja jest ważna, aby wiedzieć, czy awaria rzeczywiście jest awarią |

Z tury archiwalnej wynikają cztery wnioski, które bezpośrednio kształtują specyfikację. Po pierwsze, użytkownicy chcą otrzymywać powiadomienia, a nie musieć samodzielnie sprawdzać aplikacji - powiadomienie było jedynym elementem wskazanym we wszystkich czterech odpowiedziach na pytanie o cechę niezbędną. Po drugie, oczekują kontroli nad ilością i rodzajem informacji: chcą zaznaczyć, czy interesuje ich całe miasto, czy tylko własna ulica, i chcą móc wyłączyć wybrane kategorie, aby uniknąć szumu informacyjnego. Po trzecie, w trakcie przerwy najważniejsze są czas trwania i szacowany czas naprawy, a przy przerwach planowanych - informacja z wyprzedzeniem; przyczyna jest istotna dla części rozmówców, a obszar przerwy dla większości okazuje się drugorzędny, dopóki nie trzeba ocenić, czy problem jest powszechny. Po czwarte, użytkownicy chcą wiedzieć, czy zgłoszony problem dotyczy tylko ich, czy całej okolicy, i są skłonni potwierdzać cudze zgłoszenia, nawet jeśli sami nie chcą wypełniać formularza.

Tura bieżąca objęła trzy osoby różniące się trybem życia i sposobem korzystania z usług; zestawienie odpowiedzi przedstawia tabela.

| Pytanie | User 1 - student uniwersytetu wrocławskiego | User 2 - osoba z 2 domostwami | User 3 - osoba pracująca |  |
| :---- | :---- | :---- | :---- | :---- |
| ostatnia sytuację braku usługi | ok. tydzień temu - przerwa w dostawie wody w pralni | ok. miesiąc temu - braki w dostawie prądu z powodu burzy | ok. miesiąc temu - braki w dostawie prądu z powodu burzy |  |
| pierwszą reakcję | poszukiwanie zamiennika | przeczekanie | przeczekanie |  |
| oczekiwany zakres informowanych usług | usługi podstawowe (woda, prąd, gaz, ocieplanie) | usługi podstawowe, wycieki na stronach | usługi podstawowe, problemy na drodze (korki, wypadki) |  |
| rodzaj informacji potrzebnej w trakcie przerwy | potwierdzenie awarii | lista dostawców aktualnie ofiarą awarii, ETA końca awarii | alternatywne rozwiązania |  |
| preferowaną platformę | Telefon (strona) | Desktop | Telefon (aplikacja mobilna) |  |
| liczbę obserwowanych lokalizacji | lokalizacja | możliwość śledzenia wielu lokalizacji | lokalizacja |  |
| najważniejszą cechę aplikacji | wiarygodność danych | wiarygodność danych, szczegółowość informacji, powiadomienia | wygoda użycia |  |
| zaufanie do danych pochodzących od innych użytkowników | pełna | nacisk o informacje pochodzące z bardziej zaufanych źródeł | pełna |  |

Wywiady tury bieżącej potwierdzają część ustaleń archiwalnych i w dwóch miejscach je korygują. Potwierdzają potrzebę powiadomień, znaczenie czasu trwania przerwy i terminu jej zakończenia oraz zainteresowanie informacją o tym, czy problem dotyczy tylko jednej osoby. Najważniejszą cechą aplikacji okazała się jednak wiarygodność danych, wskazana przez dwie z trzech osób, podczas gdy w turze archiwalnej nie pojawiła się ona w żadnej odpowiedzi na pytanie o cechę niezbędną. Zaufanie do treści społecznościowych nie jest bezwarunkowe: dwie osoby darzą je pełnym zaufaniem, a jedna oczekuje wskazania, które źródło jest bardziej wiarygodne, co uzasadnia rozróżnienie w interfejsie informacji oficjalnej i zgłoszenia użytkownika.

Korekta dotyczy także pierwszej reakcji, platformy i liczby miejsc. Dwie z trzech osób deklarują przeczekanie, a nie poszukiwanie informacji, i tylko jedna szuka rozwiązania zastępczego, co oznacza, że przerwa musi trwać wystarczająco długo, aby użytkownik w ogóle sięgnął po informację. Jedna osoba wskazała komputer, jedna stronę internetową w telefonie, a jedna aplikację mobilną, przy czym dwie z trzech chcą śledzić wyłącznie własną lokalizację. Obserwowanie wielu miejsc pozostaje zatem potrzebne, ale nie jest uniwersalne, a powiadomienie push nie jest jedynym oczekiwanym kanałem dotarcia. Nowym wątkiem, którego tura archiwalna nie zawierała, jest oczekiwanie rozwiązań alternatywnych w trakcie przerwy oraz potwierdzenia, że awaria jest już znana dostawcy.

Zestawienie obu tur daje wspólny rdzeń wymagań: powiadomienie zamiast sprawdzania, czas trwania i szacowany czas naprawy jako najważniejsza treść komunikatu, kontrola nad zakresem obserwowanych usług i miejsc oraz informacja o tym, czy problem dotyczy tylko jednej osoby. Różnice - wiarygodność źródła, rozwiązania alternatywne i kanał dotarcia - zawężają ten rdzeń i uzasadniają podział funkcjonalności przyjęty w rozdziale 3.

Uzupełniającym źródłem wiedzy jest **analiza dwóch serwisów konkurencyjnych** przeprowadzona metodą przeglądu heurystycznego oraz **testy moderowane makiety cyfrowej** z pięcioma użytkownikami i siedmioma zadaniami, wykonane dwa semestry temu, na etapie projektowania makiety. Testy ujawniły między innymi, że przycisk powiadomień był zbyt mało czytelny, użytkownicy klikali w blok usługi zamiast w przycisk detali, mieli trudność ze znalezieniem funkcji zgłaszania awarii, a nazwa zakładki „Szukaj” nie kojarzyła się z listą usług. Wnioski te stanowią uzasadnienie zakresu poszczególnych funkcjonalności w rozdziale 3 oraz podstawę poprawek interfejsu.

### 2.2 Cel aplikacji

Celem aplikacji jest dostarczenie użytkownikowi w jednym miejscu aktualnej informacji o przerwach w dostawach mediów i usług oraz o zakłóceniach w działaniu usług cyfrowych i komunikacyjnych, w sposób, który nie wymaga od niego systematycznego sprawdzania stanu. Aplikacja ma odpowiadać na trzy pytania zadawane w momencie awarii: czy to dotyczy mnie, jak długo to potrwa i co mogę zrobić w zamian. Odpowiedź na pierwsze pytanie budowana jest z danych o lokalizacji i zasięgu przerwy, na drugie - z okna czasowego, szacowanego czasu naprawy i historii podobnych zdarzeń, na trzecie - z propozycji alternatyw dla usług komunikacyjnych oraz z informacji o usługach, które w danej chwili działają prawidłowo.

Cel drugi, równie istotny, wynika z wariantu redesignu: aplikacja ma być zrozumiała także dla użytkowników o niskim zaznajomieniu z technologią oraz dla dzieci, których nie interesują techniczne szczegóły, a które potrzebują krótkiej i spokojnej informacji. Oznacza to ograniczenie liczby elementów na ekranie, rezygnację z żargonu na rzecz słownika pojęć oraz możliwość ukrycia treści, które mogą niepokoić.

### 2.3 Zadania realizowane za pomocą aplikacji

Zadania użytkownika grupują się w cztery obszary. Pierwszy to **sprawdzenie statusu**: użytkownik wyszukuje usługę lub dostawcę, wybiera go z listy albo otwiera kartę z ulubionej grupy i odczytuje stan, przyczynę, okno czasowe i zasięg przerwy, a w razie potrzeby sprawdza, czy awaria dotyczy tylko jego lokalizacji. Drugi to **docieranie informacji**: użytkownik ustala, o których usługach i w jakich miejscach chce być informowany, definiuje reguły (na przykład tylko przerwy planowane, z jednodniowym wyprzedzeniem) i odbiera powiadomienia, dzięki którym nie musi sam sprawdzać stanu usług. Trzeci to **zaufanie do informacji**: użytkownik zgłasza awarię, potwierdza cudze zgłoszenie, sprawdza liczbę zgłoszeń w okolicy oraz przegląda historię przerw i wskaźnik niezawodności dostawcy, aby ocenić wiarygodność komunikatu. Czwarty to **działanie zastępcze**: przy zakłóceniach w komunikacji miejskiej użytkownik otrzymuje propozycję alternatywnego połączenia i porównanie czasu dojazdu, aby móc zrealizować swoje obowiązki mimo przerwy.

Do zadań obsługiwanych dodatkowo należą: dodanie do katalogu usługi spoza bazy (na przykład strony uczelni albo projektu personalnego), zarządzanie wieloma lokalizacjami odpowiadającymi domowi, pracy i miejscu zamieszkania rodziny oraz przeglądanie historii przerw w celu usprawiedliwienia spóźnienia.

### 2.4 Docelowa grupa użytkowników

Grupą docelową są osoby korzystające z usług zewnętrznych dostawców: energii elektrycznej, gazu, wody, internetu, komunikacji miejskiej, dróg oraz usług cyfrowych. Wspólną cechą tej grupy jest brak czasu i niechęć do aktywnego monitorowania stanu usług - wszyscy rozmówcy z wywiadów deklarowali, że sprawdzają informacje dopiero wtedy, gdy coś przestanie działać.

W obrębie grupy wyróżniono cztery profile: dzieci i młodzież w wieku szkolnym, studentów, młodych dorosłych oraz dorosłych, w tym osoby starsze. Wymaganie instrukcji, aby potencjalnymi użytkownikami były dzieci i/lub osoby starsze, jest spełnione przez profil dziecka i nastolatka, a dodatkowo aplikacja jest projektowana dla osób dorosłych o niskim zaznajomieniu z technologią, do których w praktyce należą osoby starsze. Konsekwencją jest wymaganie dostępności opisane w rozdziale 3 jako funkcjonalność F8, a także rezygnacja z gęstych ekranów analitycznych na rzecz krótkich komunikatów.

### 2.5 Technologia implementacji

	Frontend - Flutter  
	Backend - Django Python  
	Basa danych - Postgre SQL

## 3. Kontekst i przypadki użycia

Rozdział opisuje, kim są użytkownicy, w jakim środowisku będą pracować z aplikacją, jakie zadania realizują oraz jakie czynniki sprzyjają interakcji i jakie jej zagrażają.

### 3.1 Cechy użytkowników, środowisko użycia i persony

#### 3.1.1 Cechy użytkowników

Cechą wspólną wszystkich profili jest ograniczona uwaga poświęcana usługom dostawców: użytkownik sięga po informację dopiero pod wpływem zdarzenia, najczęściej w sytuacji, gdy brakuje prądu, wody, internetu albo połączenia. Wiedza techniczna jest bardzo zróżnicowana - od uczniów biegle poruszających się w aplikacjach mobilnych po dorosłych, którzy deklarują przeciętne lub niskie zaznajomienie z oprogramowaniem. Wszyscy badani oczekują informacji krótkiej i jednoznacznej, a nadmiar szczegółów technicznych uznają za obciążenie. Istotną cechą jest też mobilność: część użytkowników przebywa w ciągu dnia w kilku miejscach (dom, uczelnia lub praca, miejsce zamieszkania rodziny), dlatego informacja przypisana wyłącznie do bieżącej lokalizacji jest niewystarczająca.

#### 3.1.2 Elementy i aspekty środowiska użycia

Środowisko użycia jest zmienne i często nieprzyjazne. Przerwa w dostawie internetu oznacza, że aplikacja działa w warunkach ograniczonej łączności, co nakłada wymaganie pracy na danych ostatnio pobranych i czytelnego oznaczenia informacji nieaktualnej. Przerwa w dostawie prądu wiąże się z kolei z rozładowanym telefonem, więc czas do informacji musi być krótki. Użytkownik sprawdza status w pośpiechu - w drodze, przed wyjściem z domu, w trakcie dojazdu - często jedną ręką i w złych warunkach oświetleniowych, co uzasadnia duże cele dotykowe i wysoki kontrast. Część sytuacji ma charakter społeczny: informacja bywa potrzebna do usprawiedliwienia spóźnienia wobec wykładowcy lub pracodawcy, co czyni wiarygodność i możliwość udokumentowania przerwy osobnym wymaganiem. W tle występuje też kontekst emocjonalny: użytkownicy, zwłaszcza dzieci, deklarują niechęć do treści alarmujących, dlatego środowisko użycia obejmuje także potrzebę ograniczenia bodźców niepokojących.

#### 3.1.3 Persony

W badaniach wyróżniono cztery profile użytkowników:

* **Dziecko**: (10–19 lat, uczeń, miasto lub wieś) spędza wolny czas w internecie i w grach, wysoko ocenia własną biegłość w aplikacjach mobilnych, ale nisko w obsłudze oprogramowania. Chce sprawdzać informacje szybko i bez nudy, chce znać czas trwania i powód przerwy, nie chce widzieć treści, które mogą je zaniepokoić, i oczekuje prostej nawigacji opartej na symbolach.  
    
* **Student**: (19–25 lat, akademik lub wynajmowane mieszkanie, praca na pół etatu) przebywa poza domem w różnych porach i potrzebuje informacji o kilku miejscach jednocześnie, wczesnych powiadomień o przerwach planowanych, dostępu do mniej popularnych usług, takich jak strona uczelni, oraz alternatyw dla komunikacji miejskiej.  
    
* **Młody dorosły**: (25–35 lat, wynajmowane mieszkanie w mieście, praca projektowa) oczekuje informacji natychmiastowej i dokładnej, personalizacji powiadomień, przejrzystości przyczyn i czasu przywrócenia usług oraz potwierdzenia społecznościowego; ceni szybkość i prostotę, a obawia się dezinformacji.  
    
* **Dorosły**:(30–60 lat, duże miasto, praca w marketingu cyfrowym) chce jednego miejsca, w którym sprawdzi status, powiadomień bez spamu, rozróżnienia problemu lokalnego od powszechnego, potwierdzenia, że informacja pochodzi z oficjalnego źródła, oraz wcześniejszych informacji o wyłączeniach planowanych.

### 3.2 Zadania realizowane przez użytkowników

#### 3.2.1 Historyjki użytkownika

Historyjki spisano dla każdej persony oraz dla potrzeb wspólnych. Dziecko formułuje trzy oczekiwania: chce sprawdzać informacje bez spędzania w aplikacji długiego czasu, chce wiedzieć, jak długo potrwa przerwa i z jakiej wynika przyczyny, oraz nie chce widzieć informacji, które mogłyby je zmartwić. Student chce otrzymywać powiadomienia z wyprzedzeniem, aby zaplanować dzień, chce mieć dostęp do mniej popularnych stron, takich jak strona uczelni czy projekty personalne, chce widzieć alternatywy dla usług, z których nie może skorzystać, oraz chce móc wyłączyć powiadomienia o wybranych usługach, aby nie otrzymywać spamu.

Młody dorosły chce wiedzieć, czy przerwa wynika z awarii, konserwacji czy problemu lokalnego, aby szybko zmienić plan dnia lub zgłosić usterkę; chce ustawić, które usługi i obszary go interesują; chce też jednym przyciskiem potwierdzić cudze zgłoszenie, aby wesprzeć społeczność i zwiększyć dokładność raportu. Dorosły chce mieć jedno miejsce do sprawdzania statusu usług zamiast kilku stron i aplikacji, chce powiadomień ograniczonych do własnych lokalizacji i usług, chce rozróżnić przerwę dotyczącą tylko jego mieszkania od przerwy w całej okolicy, chce mieć pewność, że informacje pochodzą z oficjalnych i sprawdzonych źródeł oraz chce wiedzieć o planowanych wyłączeniach z wyprzedzeniem.

Potrzeby wspólne ujęto w pięciu historyjkach: natychmiastowe powiadomienia push o przerwach, pełniejsza informacja o usłudze (czas trwania i powód), widoczna liczba osób zgłaszających ten sam problem w pobliżu, możliwość śledzenia przerw w kilku wybranych obszarach bez zmiany ustawień oraz dostęp do historii przerw i napraw, służącej zarówno usprawiedliwieniu spóźnienia, jak i ocenie wiarygodności dostawcy.

#### 3.2.2 Przypadki użycia

Przypadki użycia uporządkowano w cztery grupy i oznaczono identyfikatorami CU-01 do CU-07, używanymi dalej w całym dokumencie.

* **Sprawdzanie awarii** obejmuje trzy przypadki. CU-01 to sprawdzenie usługi lub serwisu: użytkownik otwiera aplikację, wpisuje nazwę albo wybiera usługę z listy, a system zwraca status (brak problemów, awaria, przerwa techniczna, inny problem) oraz liczbę zgłoszeń z ostatniej godziny; gdy status jest inny niż „brak problemów”, system podaje szacowany czas powrotu do sprawności i oficjalne stanowisko dostawcy, a przy ustalonej lokalizacji porównuje stan ogólny ze stanem w tym miejscu. CU-02 to sprawdzenie usług publicznych, na przykład linii komunikacji miejskiej: użytkownik wpisuje numer linii lub nazwę usługi, a system zwraca status, opóźnienie i mapę przystanków, a po wskazaniu przystanku proponuje alternatywny dojazd wraz z porównaniem czasu. CU-03 to sprawdzenie „swoich” usług: użytkownik wchodzi w zakładkę z grupą oznaczoną jako główna i widzi zbiorczy status usług w tej grupie.  
    
* **Sprawdzanie historii awarii** (CU-04, aktorzy: młody dorosły i student) polega na wybraniu usługi i wejściu w zakładkę historii, gdzie system zwraca listę znanych przerw z czasem trwania i przyczyną oraz wykres liczby zgłoszeń w okresie ostatniego tygodnia, miesiąca lub trzech miesięcy.  
    
* **Ustalanie powiadomień** obejmuje dwa przypadki. CU-05 to konfiguracja powiadomień: użytkownik wchodzi w zakładkę powiadomień, wybiera usługę, zaznacza chęć otrzymywania powiadomień i przypisuje usługę do grupy. CU-06 to zarządzanie grupą jako scenariusz alternatywny: użytkownik wchodzi w widok grup, wybiera grupę i może wyłączyć powiadomienia wszystkich usług w grupie, zmienić jej lokalizację, usunąć grupę lub usunąć z niej pojedynczą usługę.  
    
* **Zgłaszanie awarii** (CU-07, aktorzy: dorosły i młody dorosły) polega na wypełnieniu formularza: użytkownik wyszukuje usługę, podaje czas trwania awarii w formie przedziału („od 30 minut”, „od godziny”), opcjonalnie dodaje lokalizację i wysyła zgłoszenie, które trafia do puli zgłoszeń danej usługi.

#### 3.2.3 Scenariusze

Scenariusze opisują przebieg pracy użytkownika w kontekście, a nie w izolacji od niego. Scenariusz studenta rozpoczyna się rano, gdy w akademiku nie działa internet: student otwiera aplikację, widzi grupę „Uczelnia” i status usługi, dowiaduje się, że przerwa jest planowana i potrwa do godziny czternastej, po czym sprawdza, czy zajęcia odbywają się w trybie zdalnym. Scenariusz młodego dorosłego dotyczy awarii nieplanowanej: po powrocie do mieszkania okazuje się, że nie działa prąd, użytkownik potwierdza jednym kliknięciem zgłoszenie sąsiada, widzi, że w promieniu kilometra zgłosiło je kilkadziesiąt osób, i uznaje, że nie ma sensu zgłaszać usterki indywidualnie. Scenariusz dorosłego obejmuje planowane wyłączenie wody, o którym aplikacja informuje dzień wcześniej, co pozwala przygotować zapas wody i przełożyć pranie. Scenariusz dziecka dotyczy platformy gier: użytkownik sprawdza, czy awaria dotyczy tylko jego urządzenia, a następnie odkrywa w słowniku pojęć, czym różni się awaria od konserwacji, i nie napotyka przy tym informacji o wypadkach.

Scenariusze te są podstawą scenariuszy badań użyteczności.

### 3.3 Funkcjonalności aplikacji

Instrukcja wymaga, aby aplikacja zawierała co najmniej dwie główne funkcjonalności dla każdego członka grupy. Zespół liczy cztery osoby, dlatego wyodrębniono **osiem funkcjonalności**, po dwie dla każdej osoby. Podział nie jest przypadkowy: funkcjonalności łączą się w pary tworzące spójne obszary odpowiedzialności, dzięki czemu każdy członek zespołu prowadzi własny wątek od scenariusza badań, przez warianty interfejsu, po ponowne badania.

Wybór zakresu opiera się na trzech przesłankach: historyjkach użytkownika z punktu 3.2.1, wnioskach z wywiadów opisanych w rozdziale 2.1 oraz wynikach testów makiety cyfrowej, które wskazały elementy wymagające poprawy. Każda funkcjonalność ma zamknięty zakres, aby w etapie implementacji nie rozrastała się poza założenia.

#### 3.3.1 Obszar: przeglądanie usług

**F1 - Katalog i wyszukiwanie usług.** 

* Osoba odpowiedzialna: Natalia Suda

Funkcjonalność obejmuje ekran „Usługi”, na którym użytkownik wyszukuje dostawcę lub usługę, przegląda kafle kategorii (Media, Internet, Komunikacja, Drogi, Usługi online) i widzi sekcje „Ostatnio sprawdzane” oraz „Twoje usługi”. Zmiana polega na poprawie tego, co w testach okazało się nieczytelne - nazwa zakładki „Szukaj” zostaje zastąpiona nazwą „Usługi”, a wyniki wyszukiwania pozwalają od razu dodać usługę do grupy - oraz na rozszerzeniu zakresu o ukrywanie wybranych kategorii, wyszukiwanie odporne na literówki i dodawanie usług spoza katalogu przez adres URL. Rozszerzenie odpowiada historyjkom o dostępie do mniej popularnych stron, takich jak strona uczelni czy projekt personalny, oraz potrzebie ograniczenia treści nieistotnych. Kryterium akceptacji zakłada znalezienie usługi w czasie do piętnastu sekund i skuteczność na poziomie dziewięćdziesięciu procent.

**F2 - Karta statusu i skala przerwy.**

* Osoba odpowiedzialna: Natalia Suda

Funkcjonalność obejmuje ekran szczegółów usługi: status w jednym z trzech stanów (działa, przerwa, problem lokalny) opisany jednocześnie tekstem, ikoną i kolorem, przyczynę przerwy, okno czasowe, szacowany czas naprawy, postęp prac, informację o źródle danych oraz zasięg przerwy. Zmiana naprawia problem ujawniony w testach, w których użytkownicy klikali w blok usługi zamiast w przycisk detali - teraz kliknięcie w blok otwiera szczegóły. Rozszerzeniem jest skala przerwy: liczba zgłoszeń w okolicy z ostatniej godziny oraz mapa z zaznaczonymi ulicami objętymi awarią, z przełącznikiem między widokiem lokalnym a widokiem całej usługi. To rozszerzenie odpowiada wprost na oczekiwanie zgłoszone przez jednego z uczestników testów oraz na historyjki o rozróżnieniu problemu lokalnego od powszechnego.

#### 3.3.2 Obszar: docieranie do informacji

**F3 - Powiadomienia i reguły alertów.**

* Osoba odpowiedzialna: Hubert Tański

Funkcjonalność obejmuje konfigurację powiadomień dla usług i grup oraz reguły określające, kiedy powiadomienie ma zostać wysłane: tylko przerwy planowane lub tylko awarie, próg czasu trwania, wyprzedzenie dla przerw planowanych (dwie godziny lub jeden dzień) i ciche godziny. Użytkownik wybiera też kanał - powiadomienie push lub SMS. Zmiana dotyczy czytelności: w miejsce mało sugestywnego dzwonka pojawia się jawny przełącznik widoczny na karcie usługi i na liście grupy, a powiadomieniami można sterować zbiorczo dla całej grupy bez usuwania z niej usług. Rozszerzenie wynika z historyjek o unikaniu spamu i o powiadomieniach z wyprzedzeniem; kryterium akceptacji zakłada, że wszyscy uczestnicy testu wskażą przełącznik w ciągu pięciu sekund, a konfiguracja reguły zajmie nie więcej niż dziewięćdziesiąt sekund.

**F4 - Lokalizacje i grupy usług.**

* Osoba odpowiedzialna: Hubert Tański

Funkcjonalność obejmuje ekran „Moje grupy” wraz z zarządzaniem lokalizacjami. Użytkownik tworzy grupy o własnych nazwach (na przykład „Dom”, „Uczelnia”, „Rodzina”), przypisuje im lokalizacje i promień, oznacza jedną grupę jako główną oraz zmienia nazwę lub lokalizację, usuwa grupę, a także wyłącza powiadomienia całej grupy. Lokalizacje są wskazywane z mapy albo przez jednorazowe użycie geolokalizacji, bez śledzenia w tle. Zmiana porządkuje to, co w testach było niejasne: użytkownicy próbowali dodawać usługi obok grupy albo wchodzili w grupę zamiast w usługę, a przy tworzeniu grupy bez nazwy nie otrzymywali czytelnego komunikatu. Rozszerzenie o wiele lokalizacji odpowiada historyjce osoby mieszkającej w jednym miejscu, pracującej w drugim i odwiedzającej rodzinę w trzecim.

#### 3.3.3 Obszar: zaufanie i społeczność

**F5 - Zgłaszanie i potwierdzanie awarii.**

* Osoba odpowiedzialna: Kacper Tomczyk

Funkcjonalność obejmuje formularz zgłoszenia dostępny na jednym ekranie - z usługą wstępnie wypełnioną, presetami czasu trwania (piętnaście, trzydzieści, sześćdziesiąt minut) i opcjonalną lokalizacją - a także tryb potwierdzenia cudzego zgłoszenia jednym przyciskiem „u mnie też nie działa”, bez wypełniania formularza. Do funkcjonalności należy też widoczność liczby zgłoszeń w okolicy, próg uznania zgłoszenia za potwierdzone przez społeczność, oznaczenie zgłoszeń niepotwierdzonych oraz limit i możliwość wycofania własnego zgłoszenia. Zmiana dotyczy dostępności funkcji: w testach użytkownicy nie potrafili jej znaleźć, dlatego wejście do zgłoszenia pojawia się w trzech miejscach - na karcie usługi, na liście usług i w powiadomieniu. Kryterium akceptacji zakłada samodzielne znalezienie funkcji przez dziewięćdziesiąt procent uczestników i czas zgłoszenia do dwudziestu sekund.

**F6 - Historia przerw i wiarygodność dostawcy.**

* Osoba odpowiedzialna: Kacper Tomczyk

Funkcjonalność rozwija ekran historii awarii, który w makiecie istniał w szczątkowej formie. Użytkownik widzi listę przerw z datą, czasem trwania, przyczyną, typem (planowana lub nieplanowana) i źródłem, wykres zgłoszeń w zakresach siedmiu dni, trzydziestu dni i trzech miesięcy z nałożonymi oficjalnymi przerwami, a także wskaźnik niezawodności dostawcy obejmujący liczbę przerw, średni czas trwania i udział przerw planowanych. Nowym elementem jest „dowód przerwy” - generowane podsumowanie z datą, godzinami i nazwą dostawcy, możliwe do przedstawienia wykładowcy lub pracodawcy. Rozszerzenie wynika z historyjki o usprawiedliwieniu spóźnienia i z potrzeby oceny wiarygodności dostawcy; w prototypie dane historyczne są demonstracyjne i oznaczone jako przykładowe.

#### 3.3.4 Obszar: mobilność i dostępność

**F7 - Komunikacja miejska i alternatywne połączenia.**

* Osoba odpowiedzialna: Jakub Borsuk

Funkcjonalność obejmuje ekran linii i przystanku: status (punktualnie, opóźnienie, objazd, awaria), mapę przystanków na trasie oraz - co stanowi właściwe rozszerzenie - propozycję alternatywnego połączenia na wybrany przystanek wraz z porównaniem czasu i liczby przesiadek. Alternatywa jest dostępna w najwyżej dwóch krokach od statusu linii. Linię można dodać do grupy i objąć regułami powiadomień, co spina tę funkcjonalność z F3 i F4. Rozszerzenie odpowiada historyjce studenta, który potrzebuje alternatywy, aby wywiązać się z obowiązków; dotychczasowy wątek komunikacji kończył się na statusie i opóźnieniu.

**F8 - Tryb uproszczony i dostępność.**

* Osoba odpowiedzialna: Jakub Borsuk

Funkcjonalność jest nowa i wynika z wymagania, aby użytkownikami były dzieci i/lub osoby starsze. Obejmuje przełączalny tryb uproszczony z maksymalnie trzema informacjami na ekranie, dużą typografią i ikonami opatrzonymi krótkim tekstem, filtr treści niepokojących (wypadki, alerty masowe) domyślnie włączony dla profilu dziecka i przełączalny przez opiekuna, ustawienia dostępności (rozmiar tekstu, kontrast, tryb ciemny, obsługa czytnika ekranu, cele dotykowe o rozmiarze co najmniej 48 dp) oraz słownik pojęć wyjaśniający różnicę między awarią, konserwacją i problemem lokalnym. W ramach tej funkcjonalności powstaje również ekran powitalny z trzema krokami, pełniący rolę alternatywnej formy wsparcia użytkownika. Tryb jest przełączalny, a nie globalny, aby nie odbierać informacji użytkownikom oczekującym szczegółów.

#### 3.3.5 Pokrycie person i historyjek

Wszystkie historyjki z punktu 3.2.1 mają przypisanie do funkcjonalności. Dziecko korzysta z F1, F2, F3 i F8; student z F1, F2, F3, F4, F6 i F7; młody dorosły z wszystkich funkcjonalności poza F8; dorosły z wszystkich ośmiu. Każda persona ma zatem pokrycie w co najmniej trzech funkcjonalnościach, a żadna funkcjonalność nie istnieje bez uzasadnienia w historyjce lub w wyniku testów.

#### 3.3.6 Zakres poza redesignem

Poza zakresem pozostają funkcje, które pojawiły się w profilach person jako zachcianki, ale nie wynikają z potrzeb potwierdzonych w wywiadach: integracja z asystentami domowymi, grywalizacja i funkcje społecznościowe polegające na dzieleniu się problemami, automatyczne zgłaszanie awarii bezpośrednio do dostawców oraz płatności. Ich włączenie zaburzyłoby równy podział pracy i rozmyłoby cel aplikacji, jakim jest szybka, wiarygodna informacja o przerwie.

### 3.4 Analiza SWOT i QFD

#### 3.4.1 SWOT

Analiza SWOT pozwala określić mocne i słabe strony projektu, a także szanse i zagrożenia wynikające z jego realizacji oraz sposobu interakcji użytkowników z aplikacją.

**S - Strengths (Mocne strony)**

* Użytkownik może sprawdzić informacje o awariach różnych dostawców w jednym miejscu, bez konieczności przeszukiwania stron i aplikacji  
* Powiadomienia push - użytkownik otrzymuje informacje o awariach automatycznie, bez konieczności samodzielnego sprawdzania statusu   
* Dostępność dla różnych grup użytkowników - tryb uproszczony, regulacja wielkości tekstu, kontrastu zwiększają dostępność aplikacji  
* Wsparcie społecznościowe - możliwość zgłaszania i potwierdzania awarii przez innych użytkowników pomaga ocenić zasięg problemu  
* Funkcja generowania “dowodu przerwy” do celów usprawiedliwienia spóźnienia


**W- Weaknesses (Słabe strony)**

* Zależność od dostępności danych zewnętrznych - kompletność i aktualność informacji zależą od dostawców oraz dostępnych źródeł danych, podatność na opóźnienia w aktualizacji statusów

**O - Opportunities (Szanse)**

* Zwiększenie świadomości użytkowników - aplikacja może ułatwić planowanie codziennych obowiązków dzięki wcześniejszemu informowaniu o planowanych przerwach  
* Im więcej użytkowników potwierdza awarie, tym wyższa wiarygodność i szybkość informacji


**T - Threats (Zagrożenia)**

* Nieaktualne lub nieprawdziwe informacje   
* Problemy techniczne dostawców - niedostępność zewnętrznych systemów może ograniczyć możliwość prezentowania aktualnych informacji.  
* Niska wiarygodność zgłoszeń społecznościowych - użytkownicy mogą przekazywać nieprawdziwe informacje lub błędnie potwierdzać występowanie awarii  
* Nadmierna liczba powiadomień - zbyt częste alerty mogą powodować irytację i skłaniać użytkowników do wyłączenia powiadomień  
* Ograniczenia sieciowe - ryzyko braku dostępu do sieci po stronie użytkownika

#### 3.4.2 QFD

Waga wymagania, w skali od 1 do 4, odpowiada liczbie person, których historyjki obejmują daną potrzebę;
potrzeby wspólne (punkt 3.2.1) oraz wynikające z testów makiety i z instrukcji otrzymały wagę 4. Siłę
powiązania oceniono w skali 9 (silne), 3 (średnie), 1 (słabe); puste pole oznacza brak powiązania. Ważność
charakterystyki jest sumą iloczynów wag i siły powiązań.

*TODO - zweryfikować wagi na podstawie ocen ważności zebranych w wywiadach.*

**Wymagania użytkowników (WHAT)**

| ID | Wymaganie użytkownika | Źródło | Waga |
|---|---|---|---|
| W1 | Powiadomienia docierające bez samodzielnego sprawdzania | potrzeba wspólna | 4 |
| W2 | Czas trwania przerwy i szacowany czas naprawy | potrzeba wspólna | 4 |
| W3 | Przyczyna i typ przerwy (awaria, konserwacja, planowana) | potrzeba wspólna | 4 |
| W4 | Rozróżnienie problemu lokalnego od powszechnego, liczba zgłoszeń w okolicy | potrzeba wspólna | 4 |
| W5 | Potwierdzenie cudzego zgłoszenia jednym kliknięciem | młody dorosły | 1 |
| W6 | Kontrola nad powiadomieniami, brak spamu, informacja z wyprzedzeniem | student, młody dorosły, dorosły | 3 |
| W7 | Śledzenie kilku lokalizacji i grup usług bez zmiany ustawień | potrzeba wspólna | 4 |
| W8 | Krótka, spokojna informacja bez treści niepokojących | dziecko | 1 |
| W9 | Historia przerw, wiarygodność dostawcy, możliwość udokumentowania przerwy | potrzeba wspólna | 4 |
| W10 | Alternatywa dla niedziałającej komunikacji miejskiej | student | 1 |
| W11 | Dostęp do usług spoza katalogu (strona uczelni, projekt personalny) | student | 1 |
| W12 | Łatwość znalezienia funkcji i przycisków | testy makiety | 4 |
| W13 | Dostępność dla dzieci i osób o niskim zaznajomieniu z technologią | instrukcja | 4 |

**Charakterystyki techniczne (HOW)**

| ID | Charakterystyka techniczna | Miara | Funkcjonalność |
|---|---|---|---|
| H1 | Katalog i wyszukiwanie usług z dodawaniem spoza katalogu | znalezienie usługi do 15 s, skuteczność 90% | F1 |
| H2 | Kompletność karty statusu (przyczyna, okno czasowe, czas naprawy, źródło, zasięg) | liczba kroków od listy do szczegółów | F2 |
| H3 | Skala przerwy: liczba zgłoszeń w okolicy i mapa zasięgu | zgłoszenia z ostatniej godziny, widok lokalny i ogólny | F2, F5 |
| H4 | Reguły i kanały powiadomień | konfiguracja reguły do 90 s, przełącznik wskazany w 5 s | F3 |
| H5 | Lokalizacje i grupy usług | liczba lokalizacji i grup, zbiorcze sterowanie grupą | F4 |
| H6 | Zgłaszanie i potwierdzanie awarii | zgłoszenie do 20 s, wejście w trzech miejscach, 90% znajduje funkcję | F5 |
| H7 | Historia przerw, wskaźnik niezawodności i dowód przerwy | zakresy 7 dni, 30 dni i 3 miesiące | F6 |
| H8 | Alternatywne połączenia komunikacji miejskiej | najwyżej dwa kroki od statusu linii | F7 |
| H9 | Tryb uproszczony i ustawienia dostępności | do trzech informacji na ekranie, cele dotykowe co najmniej 48 dp | F8 |

**Macierz powiązań i ważność charakterystyk**

| WHAT \ HOW | Waga | H1 | H2 | H3 | H4 | H5 | H6 | H7 | H8 | H9 |
|---|---|---|---|---|---|---|---|---|---|---|
| W1 | 4 | | | | 9 | | | | | |
| W2 | 4 | | 9 | | | | | 3 | | |
| W3 | 4 | | 9 | | | | | 3 | | |
| W4 | 4 | | 3 | 9 | | | 3 | | | |
| W5 | 1 | | | 3 | | | 9 | | | |
| W6 | 3 | | | | 9 | 3 | | | | |
| W7 | 4 | | | | 3 | 9 | | | | |
| W8 | 1 | | 1 | | | | | | | 9 |
| W9 | 4 | | 3 | | | | | 9 | | |
| W10 | 1 | | | | 1 | | | | 9 | |
| W11 | 1 | 9 | | | | 1 | | | | |
| W12 | 4 | 3 | 3 | | 3 | | 9 | | | |
| W13 | 4 | 1 | | | | | | | | 9 |
| **Ważność** | | 25 | 109 | 39 | 88 | 46 | 57 | 60 | 9 | 45 |
| **Udział [%]** | | 5,2 | 22,8 | 8,2 | 18,4 | 9,6 | 11,9 | 12,6 | 1,9 | 9,4 |

**Wnioski.** Największą ważność uzyskała kompletność karty statusu (H2, 22,8%), a w dalszej kolejności reguły
i kanały powiadomień (H4, 18,4%) oraz historia przerw i wiarygodność dostawcy (H7, 12,6%). Wynik potwierdza,
że rdzeniem aplikacji są informacja o przerwie, jej przyczynie i czasie trwania oraz docieranie tej informacji
do użytkownika bez jego interwencji, a więc obszary F2 i F3. Wysoką ważność ma także zgłaszanie i potwierdzanie
awarii (H6, 11,9%), na którą składa się zarówno zaufanie do danych, jak i problem ze znalezieniem funkcji
wykazany w testach. Najniższą ważność mają alternatywne połączenia (H8, 1,9%), ponieważ odpowiadają potrzebie
jednej persony; funkcjonalność ta pozostaje w zakresie ze względu na historyjkę studenta i powiązanie z F3 oraz F4,
natomiast jej niska pozycja uzasadnia ograniczenie zakresu do najwyżej dwóch kroków od statusu linii. Tryb
uproszczony (H9, 9,4%) ma średnią ważność w skali całego zestawu, lecz jest jedyną charakterystyką odpowiadającą
na wymaganie dostępności, dlatego nie podlega redukcji.

## 4. Scenariusze badań

### 4.1 Scenariusze badań według przypadków użycia

Scenariusze badań użyteczności odpowiadają przypadkom użycia CU-01 do CU-07 z punktu 3.2.2. Każdy scenariusz podaje sytuację, listę zadań dla uczestnika oraz oczekiwany rezultat. Numery zadań z list poniżej są używane w kryteriach punktu 4.3.

**Scenariusz 1: CU-01 - Sprawdzenie usługi lub serwisu**

Sytuacja: wracasz do domu i zauważasz, że nie masz dostępu do internetu. Nie wiesz, czy problem dotyczy wyłącznie Twojego mieszkania, czy występuje również u innych mieszkańców okolicy. Chcesz sprawdzić, co się dzieje i kiedy usługa powinna ponownie działać.

Zadania dla uczestnika:

1. Odszukaj w aplikacji usługę internetową wybranego dostawcy.
2. Sprawdź aktualny status usługi.
3. Otwórz szczegóły awarii.
4. Odszukaj informację o przyczynie i przewidywanym czasie zakończenia problemu.
5. Sprawdź, jaki obszar obejmuje awaria i ile osób zgłosiło podobny problem.

Oczekiwany rezultat: użytkownik samodzielnie odnajduje usługę, rozpoznaje jej status oraz potrafi wskazać przyczynę, przewidywany czas naprawy i zasięg awarii.

**Scenariusz 2: CU-02 - Sprawdzenie usług publicznych**

Sytuacja: jesteś studentem i jedziesz na uczelnię. Dowiadujesz się, że linia autobusowa, którą zwykle podróżujesz, ma opóźnienia. Chcesz sprawdzić aktualną sytuację i znaleźć alternatywny sposób dotarcia na miejsce.

Zadania dla uczestnika:

1. Odszukaj interesującą Cię linię komunikacji miejskiej.
2. Sprawdź jej aktualny status i informacje o opóźnieniu.
3. Otwórz mapę przystanków na trasie.
4. Wybierz przystanek docelowy.
5. Znajdź alternatywne połączenie.
6. Porównaj proponowane rozwiązania pod względem czasu podróży i liczby przesiadek.

Oczekiwany rezultat: użytkownik odnajduje linię, sprawdza jej status i potrafi wybrać alternatywne połączenie odpowiadające jego potrzebom.

**Scenariusz 3: CU-03 - Sprawdzenie własnych usług**

Sytuacja: korzystasz z kilku usług związanych z miejscem zamieszkania i pracą. Chcesz szybko sprawdzić, czy któraś z obserwowanych przez Ciebie usług ma aktualnie problemy.

Zadania dla uczestnika:

1. Przejdź do widoku swoich grup usług.
2. Odszukaj grupę oznaczoną jako główna.
3. Sprawdź zbiorczy status usług znajdujących się w tej grupie.
4. Wskaż usługę, której działanie jest nieprawidłowe.

Oczekiwany rezultat: użytkownik bez problemu odnajduje główną grupę i potrafi rozpoznać status poszczególnych usług.

**Scenariusz 4: CU-04 - Sprawdzanie historii awarii**

Sytuacja: od pewnego czasu zauważasz częste problemy z dostawą internetu u swojego dostawcy. Chcesz sprawdzić, jak często występowały awarie w ostatnim miesiącu i jak długo trwały.

Zadania dla uczestnika:

1. Odszukaj usługę internetową wybranego dostawcy.
2. Przejdź do historii awarii tej usługi.
3. Wyświetl historię z ostatniego tygodnia.
4. Zmień zakres czasowy na ostatni miesiąc, a następnie na ostatnie trzy miesiące.
5. Sprawdź, jakie awarie występowały w tym okresie oraz jak długo trwały.
6. Zapoznaj się z wykresem liczby zgłoszeń i oceń częstotliwość występowania problemów.

Oczekiwany rezultat: użytkownik odnajduje historię awarii i potrafi odczytać informacje dotyczące częstotliwości, czasu trwania oraz przyczyn występujących problemów.

**Scenariusz 5: CU-05 - Konfiguracja powiadomień**

Sytuacja: chcesz otrzymywać informacje o planowanych przerwach w dostawie wody w miejscu zamieszkania. Zależy Ci na tym, aby otrzymywać powiadomienia z jednodniowym wyprzedzeniem, ale nie chcesz dostawać alertów dotyczących każdej drobnej awarii.

Zadania dla uczestnika:

1. Odszukaj wybraną usługę wodociągową.
2. Włącz powiadomienia dla tej usługi.
3. Skonfiguruj alerty dotyczące wyłącznie planowanych przerw.
4. Ustaw jednodniowe wyprzedzenie.
5. Przypisz wybraną usługę do odpowiedniej grupy.

Oczekiwany rezultat: użytkownik samodzielnie włącza powiadomienia i ustawia reguły odpowiadające przedstawionym wymaganiom.

**Scenariusz 6: CU-06 - Zarządzanie grupą usług**

Sytuacja: niedawno zmieniłeś miejsce zamieszkania. Chcesz zaktualizować ustawienia aplikacji tak, aby jedna z Twoich grup usług wskazywała nowy adres. Przy okazji chcesz wyłączyć powiadomienia dla całej grupy, ale nie usuwać obserwowanych usług.

Zadania dla uczestnika:

1. Otwórz widok swoich grup.
2. Wybierz grupę, której lokalizację chcesz zmienić.
3. Zaktualizuj przypisaną lokalizację.
4. Wyłącz powiadomienia dla całej grupy.
5. Sprawdź, czy usługi nadal znajdują się w grupie.

Oczekiwany rezultat: użytkownik zmienia lokalizację i wyłącza powiadomienia bez przypadkowego usunięcia grupy lub należących do niej usług.

**Scenariusz 7: CU-07 - Zgłaszanie awarii**

Sytuacja: wracasz do mieszkania i zauważasz, że nie działa prąd. Sprawdzasz aplikację, ale nie widzisz jeszcze informacji o awarii w Twojej okolicy. Chcesz poinformować innych użytkowników o problemie.

Zadania dla uczestnika:

1. Odszukaj funkcję zgłaszania awarii.
2. Wybierz usługę, której dotyczy problem.
3. Określ przybliżony czas trwania awarii.
4. Opcjonalnie wskaż lokalizację.
5. Wyślij zgłoszenie.

Oczekiwany rezultat: użytkownik samodzielnie odnajduje formularz i uzupełnia wymagane informacje.

### 4.2 Ocena aplikacji

Aplikację oceniono analitycznie, bez udziału badanych, na makiecie cyfrowej. Podstawą były scenariusze badań z punktu 4.1, odpowiadające przypadkom użycia CU-01-CU-07. Zastosowano trzy metody wymagane w instrukcji: przegląd kognitywny, GOMS oraz KLM/TLM. Przegląd kognitywny bada, czy nowicjusz odkryje właściwą akcję i poprawnie odczyta odpowiedź systemu. GOMS rozkłada zadanie na cele, operatory, metody i reguły wyboru. KLM/TLM szacuje czas wykonania przez biegłego użytkownika na ekranie dotykowym i porównuje go z progami z punktu 4.3. Wyniki trzech metod zebrano w punktach 4.2.1-4.2.3; wynikające z nich problemy i propozycje poprawek zawarto w punkcie 4.4.

Obiektem oceny była istniejąca makieta, a nie specyfikacja planowanego redesignu. Tam, gdzie scenariusz wymaga funkcji nieobecnej w makiecie (reguły powiadomień, zmiana lokalizacji grupy, alternatywa komunikacyjna, zakresy historii), odnotowano brak metody zamiast uzupełniać przebieg.

#### 4.2.1 Przegląd kognitywny

Ocena metodą przeglądu kognitywnego została przeprowadzona na makiecie cyfrowej, bez udziału badanych. Badacz realizował scenariusze 1-7 z punktu 4.1, odgrywając rolę nowicjusza i „odkrywając” interfejs. Na każdym kroku stawiano cztery pytania z wykładu: co użytkownik chce osiągnąć; czy właściwe akcje są oczywiste; czy opis akcji jest klarowny; czy użytkownik poprawnie interpretuje odpowiedź systemu.

Scenariusz 1 (CU-01). Wejście w katalog jest czytelne: przycisk „Usługi” prowadzi do listy kafelków, wybór Netii jest oczywisty, a informacja o awarii widoczna jest już na kafelku. Kliknięcie kafelka otwiera kartę szczegółów w jednym kroku. Na karcie znajdują się napis statusu, czas ostatniego sprawdzenia, wykres zgłoszeń oraz heatmapa zasięgu. Brakuje przyczyny przerwy, szacowanego czasu zakończenia oraz liczby zgłoszeń podanej jako liczba; skalę zgłoszeń użytkownik musi odczytać z wykresu. Odpowiedź na czwarte pytanie jest częściowa: system potwierdza wystąpienie problemu i jego obszar, ale nie odpowiada na pytania o przyczynę i czas końca.

Scenariusz 2 (CU-02). Widok komunikacji publicznej zawiera mapę oraz jedną linię. Nie ma informacji o opóźnieniu, wyboru przystanku, propozycji alternatywnego połączenia ani porównania czasu podróży i liczby przesiadek. Właściwe akcje scenariusza nie są dostępne, więc pytania o oczywistość akcji i klarowność opisu uzyskują odpowiedź negatywną.

Scenariusz 3 (CU-03). Wejście w grupy nie sprawia trudności: przycisk z etykietą „grupy” znajduje się w lewym dolnym rogu, a po tapnięciu pojawia się czytelna lista grup. Żadna grupa nie jest oznaczona jako główna, więc użytkownik nie wie, którą powinien otworzyć, i wybiera dowolną (w próbie: „Dom”). Na liście usług status kodowany jest kolorem przycisku „I” (czerwony, żółty, zielony), bez etykiety słownej; znaczenie kolorów odczytywane jest z domysłu. Dopiero po otwarciu czerwonej pozycji (Netia) system pokazuje status, czas sprawdzenia, wykres i heatmapę, co pozwala potwierdzić awarię. Pytania dotyczące wyboru grupy głównej oraz odczytu statusu z listy kończą się negatywnie.

Scenariusz 4 (CU-04). Po wejściu w usługę widoczny jest czytelny wykres historii w zakresie tygodnia. Nie da się przełączyć zakresu na miesiąc ani na trzy miesiące i nie ma listy przerw z przyczyną oraz czasem trwania. Użytkownik nie uzyskuje informacji wymaganej w zadaniach 3-6 scenariusza.

Scenariusz 5 (CU-05). Makieta nie zawiera konfiguracji reguł (tylko przerwy planowane, wyprzedzenie jednego dnia, przypisanie konkretnej usługi do grupy). Jedyną dostępną akcją jest włączenie lub wyłączenie powiadomień całej grupy. Cel scenariusza jest nieosiągalny; właściwe akcje nie istnieją.

Scenariusz 6 (CU-06). Wyłączenie powiadomień grupy jest łatwe i nie usuwa usług z grupy. Funkcji zmiany lokalizacji grupy nie ma. Pytanie o oczywistość wyciszenia wypada pozytywnie, pytanie o zmianę lokalizacji - negatywnie.

Scenariusz 7 (CU-07). Zgłoszenie awarii polega na wyszukaniu usługi (w grupie albo w katalogu) i zatwierdzeniu chęci zgłoszenia. Formularz nie zawiera czasu trwania, lokalizacji ani innych pól. Funkcja jest znajdowalna, lecz uboższa niż w opisie przypadku użycia.

#### 4.2.2 GOMS

Modele GOMS zbudowano dla celów odpowiadających oczekiwanym rezultatom scenariuszy z punktu 4.1. Operatorami są atomowe akcje na ekranie dotykowym (tap, odczyt). Tam, gdzie makieta nie oferuje metody realizacji celu, odnotowano brak metody zamiast uzupełniać przebieg.

Scenariusz 1. Cel główny: sprawdzić awarię internetu, to znaczy ustalić, czy dotyczy użytkownika, jaka jest przyczyna, kiedy się skończy i jaki ma zasięg. Cel „znaleźć usługę” ma dwie metody: A - tap „Usługi” i tap kafelka Netia; B - wyszukiwarka na ekranie startowym. Reguła wyboru: A, gdy kafelek jest widoczny, w przeciwnym razie B. W próbie zastosowano A. Cel „odczytać status” realizuje odczyt kafelka, a następnie karty. Cel „odczytać przyczynę i czas końca” nie ma metody w makiecie. Cel „odczytać zasięg” realizuje odczyt heatmapy i wykresu.

Scenariusz 2. Cel główny: sprawdzić status linii i znaleźć alternatywne połączenie na wybrany przystanek. Jedyna metoda to otwarcie widoku komunikacji (mapa i linia). Metoda prowadząca do alternatywy i porównania czasu nie istnieje.

Scenariusz 3. Cel główny: sprawdzić, czy któraś z obserwowanych usług nie działa. Podcel „otworzyć grupy” realizuje tap „grupy”. Podcel „otworzyć grupę główną” ma metodę tapnięcia wybranej grupy, ale nie ma reguły wyboru, ponieważ system nie oznacza grupy głównej; w próbie użyto grupy „Dom”. Podcel „odczytać, która usługa nie działa” ma metodę A (odczyt koloru na liście) i metodę B (tap usługi i odczyt karty). Reguła wyboru: A, gdy kolor jest zrozumiały, B, gdy użytkownik nie ufa kolorowi. W próbie zastosowano B (Netia).

Scenariusz 4. Cel główny: ocenić częstotliwość i czas trwania awarii w ostatnim miesiącu. Metoda: tap usługi i odczyt wykresu tygodnia. Metody zmiany zakresu na 30 dni i trzy miesiące oraz odczytu listy z przyczyną i czasem trwania nie istnieją.

Scenariusz 5. Cel główny: włączyć powiadomienia o planowanych przerwach w dostawie wody z jednodniowym wyprzedzeniem i przypisać usługę do grupy. Metoda A (przełącznik i reguły na karcie usługi) nie istnieje. Metoda B (przełącznik powiadomień całej grupy) istnieje, lecz nie realizuje celu głównego. Reguła wyboru nie ma zastosowania: dostępna jest wyłącznie B.

Scenariusz 6. Cel główny: zmienić lokalizację grupy i wyłączyć jej powiadomienia bez usuwania usług. Metoda zmiany lokalizacji nie istnieje. Metoda wyciszenia: tap grupy i tap przełącznika powiadomień; usługi pozostają w grupie.

Scenariusz 7. Cel główny: zgłosić awarię. Metoda: znaleźć usługę w grupie albo w katalogu i zatwierdzić zgłoszenie. Metody podania czasu trwania („od 30 minut”) i lokalizacji nie istnieją.

#### 4.2.3 KLM/TLM

Szacowanie czasu wykonano modelem TLM jako rozszerzeniem KLM na ekran dotykowy. Z KLM (wykład) przyjęto operator mentalny M = 1,20 s. Z TLM przyjęto tap T = 0,08 s. Operatorów myszy (P, H, BB) nie stosowano. Założono, że aplikacja jest już otwarta (pominięto Initial Act). Przewijania w żadnym scenariuszu nie zaobserwowano, więc nie doliczano SC. Zapis ma postać ze slajdu z przykładem KLM: sekwencja operatorów, suma, porównanie z progiem z punktu 4.3.

Scenariusz 1, metoda A: M T M T M (initiate, tap „Usługi”, namysł nad kafelkiem, tap Netia, odczyt karty) = 3,76 s. Próg znalezienia usługi (do 15 s) jest spełniony, podobnie wymóg jednego kroku od listy do szczegółów. Próg poprawnego odczytu przyczyny, czasu zakończenia i liczby zgłoszeń nie jest spełniony, ponieważ pól tych nie ma na karcie.

Scenariusz 2: M T M (initiate, wejście w komunikację, odczyt mapy i linii) = 2,48 s. Próg „alternatywa w najwyżej dwóch krokach od statusu linii” nie podlega ocenie ilościowej, bo alternatywy nie ma.

Scenariusz 3, metoda A (odczyt koloru na liście): M T M T M = 3,76 s. Metoda B (karta Netii): M T M T M T M = 5,04 s. Punkt 4.3 nie narzuca limitu czasu dla tego scenariusza; problemem pozostaje brak grupy głównej, a nie długość ścieżki.

Scenariusz 4: M T M T M (usługa, odczyt wykresu tygodnia) = 3,76 s. Kryterium zmiany zakresu na tydzień, miesiąc i trzy miesiące nie jest spełnione.

Scenariusz 5: metody A nie liczono. Metoda B (przełącznik grupy): M T M T M T = 3,84 s. Progów „przełącznik usługi wskazany w 5 s” i „konfiguracja reguły w 90 s” nie da się odnieść do makiety, bo nie ma ani przełącznika na karcie usługi, ani reguł.

Scenariusz 6, wyciszenie grupy: M T M T M T = 3,84 s. Kryterium zachowania usług w grupie jest spełnione. Kryterium zmiany lokalizacji nie jest spełnione.

Scenariusz 7: M T M T M T (znalezienie usługi, zatwierdzenie zgłoszenia) = 3,84 s. Próg 20 s od otwarcia funkcji do wysłania jest spełniony dla biegłego użytkownika. Formularz z zadaniami 3-4 scenariusza nie istnieje.

Porównanie obu metod w scenariuszu 3 pokazuje - analogicznie do przykładu Design A / Design B z wykładu - że wejście w kartę wydłuża zadanie o jeden tap i jeden operator M (z 3,76 s do 5,04 s). Różnica jest niewielka wobec progów z punktu 4.3; wąskim gardłem nie jest czas, lecz brak etykiet i brak funkcji.

### 4.3 Miary i kryteria oceny użyteczności

Miary użyteczności zdefiniowano zgodnie z podejściem przywoływanym w ISO 9241-210, w którym użyteczność opisują skuteczność, efektywność i satysfakcja użytkownika w określonym kontekście użycia. Skuteczność oznacza, czy użytkownik osiąga cel zadania i czy robi to poprawnie, efektywność - jakim nakładem czasu i kroków, a satysfakcja - jak użytkownik subiektywnie ocenia łatwość korzystania z aplikacji. Do tych trzech wymiarów dodano czwarty, wynikający z drugiego celu redesignu opisanego w punkcie 2.2 oraz z funkcjonalności F8: dostępność i zrozumiałość interfejsu dla dzieci i osób o niskim zaznajomieniu z technologią. Każda miara ma jedną definicję obowiązującą we wszystkich scenariuszach z punktu 4.1, a progi liczbowe, które zależą od scenariusza, zebrano w osobnej tabeli kryteriów. Kryteria operacjonalizują „oczekiwany rezultat” podany przy każdym scenariuszu.

**Miary użyteczności**

| ID | Miara | Wymiar | Definicja i sposób pomiaru | Jednostka |
|---|---|---|---|---|
| M1 | Wskaźnik ukończenia zadania | skuteczność | Odsetek uczestników, którzy osiągnęli cel zadania samodzielnie i z poprawnym efektem końcowym (na przykład z ustawioną właściwą regułą powiadomień). Zadanie ukończone po podpowiedzi moderatora, porzucone lub zakończone niewłaściwym efektem liczy się jako nieukończone. | % (oraz liczebność, np. 4 z 5) |
| M2 | Liczba błędów na zadanie | skuteczność | Liczba dotknięć elementów niepowiązanych z celem zadania oraz wejść na niewłaściwy ekran, zliczana na podstawie obserwacji i nagrania sesji. | liczba, średnia na uczestnika |
| M3 | Liczba błędów krytycznych | skuteczność | Liczba działań prowadzących do utraty danych użytkownika lub skutku niezgodnego z jego zamiarem, na przykład przypadkowego usunięcia grupy albo usługi z grupy lub wysłania zgłoszenia dla niewłaściwej usługi. | liczba |
| M4 | Poprawność odczytu informacji | skuteczność | Odsetek uczestników, którzy w zadaniu odczytowym poprawnie wskazują żądane informacje (na przykład status, przyczynę, szacowany czas naprawy, zasięg i liczbę zgłoszeń albo czas trwania i częstotliwość awarii). | % |
| M5 | Czas wykonania zadania | efektywność | Czas od zakończenia czytania polecenia do osiągnięcia celu, liczony wyłącznie dla zadań ukończonych. | s, mediana |
| M6 | Liczba kroków | efektywność | Liczba dotknięć ekranu potrzebnych do osiągnięcia celu, zestawiana z liczbą kroków ścieżki optymalnej. | liczba, iloraz do ścieżki optymalnej |
| M7 | Czas wskazania elementu | efektywność | Czas od polecenia do pierwszego trafnego wskazania właściwego elementu interfejsu, na przykład przełącznika powiadomień albo wejścia do zgłoszenia awarii. | s |
| M8 | Ocena łatwości zadania (SEQ) | satysfakcja | Jedno pytanie zadawane po każdym zadaniu: jak łatwe lub trudne było jego wykonanie. | skala 1-7, średnia |
| M9 | Wynik SUS | satysfakcja | Kwestionariusz System Usability Scale, dziesięć pytań wypełnianych po zakończeniu sesji. | 0-100 |
| M10 | Nasilenie problemu użyteczności | wszystkie | Ocena każdego zaobserwowanego problemu w skali Nielsena, uwzględniająca częstość problemu, jego wpływ na wykonanie zadania i trwałość: 0 - brak problemu, 1 - kosmetyczny, 2 - drobny, 3 - poważny, 4 - katastrofalny. | 0-4 |
| M11 | Zgodność z wymaganiami dostępności | dostępność | Audyt ekranów trybu uproszczonego: liczba informacji na ekranie oraz odsetek celów dotykowych o rozmiarze co najmniej 48 dp. | liczba, % |

Ponieważ badania z użytkownikami obejmują niewielką liczbę uczestników, odsetki są zawsze podawane razem z liczebnościami, a wartości czasu - jako mediany, które są odporne na pojedyncze wyniki odstające. Miary M1-M7 oraz M10 pochodzą z obserwacji sesji, miary M8 i M9 z kwestionariuszy, a miara M11 z audytu projektu interfejsu, niezależnego od udziału użytkowników.

**Progi ogólne**

| Miara | Kryterium spełnione, gdy | Uzasadnienie progu |
|---|---|---|
| M1, M4 | co najmniej 90% uczestników | wartość z kryteriów akceptacji F1 i F5; przy małej liczbie uczestników oznacza w praktyce brak niepowodzeń |
| M3 | brak błędów krytycznych | przyjęcie zespołu |
| M8 | średnia ocena zadania wynosi co najmniej 5,5 | przeciętna wartość SEQ podawana w literaturze |
| M9 | wynik SUS wynosi co najmniej 68 | przeciętny wynik SUS podawany w literaturze |
| M10 | nie pozostaje żaden nierozwiązany problem o nasileniu 3 lub 4 | przyjęcie zespołu |

Zadanie uznaje się za wykonane poprawnie pod względem użyteczności, gdy spełnia progi ogólne dla M1, M3 i M4 oraz progi szczegółowe M5-M7 wskazane dla odpowiadającego mu scenariusza, a także próg M8; w przeciwnym razie zadanie wymaga poprawy interfejsu. Całą aplikację ocenia się łącznie, na podstawie progów M9 i M10, tak aby dobre wyniki pojedynczych zadań nie przesłaniały ogólnego odbioru produktu.

**Kryteria dla scenariuszy badań**

Numery zadań odnoszą się do list zadań dla uczestnika w punkcie 4.1.

| Scenariusz | Funkcjonalności | Miary główne | Kryterium |
|---|---|---|---|
| Scenariusz 1 (CU-01) | F1, F2 | M1, M4, M5, M6 | usługa znaleziona w czasie do 15 s (zadanie 1); przejście od listy do szczegółów w jednym kroku (zadanie 3); poprawny odczyt przyczyny, szacowanego czasu zakończenia, zasięgu i liczby zgłoszeń (zadania 4-5); M1 i M4 co najmniej 90% |
| Scenariusz 2 (CU-02) | F7, F2 | M1, M4, M6 | alternatywne połączenie znalezione w najwyżej dwóch krokach od statusu linii (zadanie 5); poprawne porównanie czasu podróży i liczby przesiadek (zadanie 6); M1 i M4 co najmniej 90% |
| Scenariusz 3 (CU-03) | F4, F2 | M1, M2, M4 | główna grupa odnaleziona (zadanie 2) i poprawnie wskazana usługa o nieprawidłowym działaniu (zadanie 4); M1 i M4 co najmniej 90%; brak błędów polegających na pomyleniu grupy z usługą |
| Scenariusz 4 (CU-04) | F6 | M1, M4 | poprawna zmiana zakresu na tydzień, miesiąc i trzy miesiące (zadania 3-4); poprawny odczyt liczby awarii, czasu trwania i przyczyn oraz ocena częstotliwości problemów (zadania 5-6); M1 i M4 co najmniej 90% |
| Scenariusz 5 (CU-05) | F3 | M1, M5, M7 | przełącznik powiadomień wskazany w czasie do 5 s przez wszystkich uczestników (zadanie 2); konfiguracja reguły w czasie do 90 s (zadania 2-5); efekt końcowy zgodny z sytuacją: powiadomienia włączone, tylko przerwy planowane, wyprzedzenie jednodniowe, usługa przypisana do grupy; M1 co najmniej 90% |
| Scenariusz 6 (CU-06) | F4, F3 | M1, M3, M4 | lokalizacja grupy zmieniona, powiadomienia grupy wyłączone, a usługi nadal w grupie (zadania 3-5); brak przypadkowego usunięcia grupy lub usługi (M3 równe 0); M1 i M4 co najmniej 90% |
| Scenariusz 7 (CU-07) | F5 | M1, M3, M5, M7 | funkcja zgłaszania znaleziona samodzielnie przez co najmniej 90% uczestników (zadanie 1); zgłoszenie wysłane w czasie do 20 s, liczonym od otwarcia funkcji do wysłania (zadania 2-5); zgłoszenie dotyczy właściwej usługi (M3 równe 0); M1 co najmniej 90% |
| Tryb uproszczony | F8 | M11 | co najwyżej trzy informacje na ekranie; wszystkie cele dotykowe o rozmiarze co najmniej 48 dp |

Kryteria dla scenariuszy 1, 2, 5 i 7 oraz dla trybu uproszczonego wynikają bezpośrednio z kryteriów akceptacji funkcjonalności F1, F2, F3, F5, F7 i F8 z punktu 3.3 oraz z charakterystyk technicznych H1-H9 z punktu 3.4.2. Kryteria dla scenariuszy 3 i 6 odnoszą się do błędów zaobserwowanych w testach makiety (pomylenie grupy z usługą, dodawanie usług obok grupy) i do oczekiwanego rezultatu scenariusza 6, a kryteria dla scenariusza 4 wynikają z zakresu funkcjonalności F6.

### 4.4 Potencjalne problemy użyteczności, analiza wyników, propozycje poprawek

Przegląd kognitywny, modele GOMS i oszacowania TLM wskazują, że wąskim gardłem makiety nie jest długość ścieżek, lecz brak elementów wymaganych przez scenariusze oraz niejednoznaczne oznaczenie statusu. Poniżej zebrano problemy i propozycje poprawek.

Po pierwsze, lista grup nie oznacza grupy głównej, więc zadanie ze scenariusza 3 nie ma poprawnej akcji. Należy dodać etykietę lub ikonę „główna” przy wybranej grupie.

Po drugie, status usługi na liście opiera się wyłącznie na kolorze przycisku „I”. Nowicjusz odgaduje znaczenie kolorów. Przy statusie powinien pojawić się tekst („awaria”, „działa”, „problem lokalny”), zgodnie z wymaganiem F2, że odczyt nie może zależeć od koloru.

Po trzecie, karta usługi nie zawiera przyczyny, szacowanego czasu zakończenia ani liczby zgłoszeń jako liczby, mimo że są to treści zadań 4 i 5 scenariusza 1 oraz charakterystyki H2 i H3. Wykres i heatmapę należy uzupełnić o te trzy pola, nie zastępować ich.

Po czwarte, powiadomienia można tylko włączyć lub wyłączyć dla całej grupy. Brakuje przełącznika na karcie usługi oraz reguł z scenariusza 5 (tylko planowane, wyprzedzenie jednego dnia, przypisanie usługi do grupy). To jest treść F3 i próg 90 s z punktu 4.3.

Po piąte, w scenariuszu 6 wyciszenie grupy działa poprawnie i nie usuwa usług; brakuje zmiany lokalizacji grupy.

Po szóste, zgłoszenie awarii sprowadza się do zatwierdzenia przy usłudze. Należy dodać presety czasu trwania i opcjonalną lokalizację, zachowując krótką ścieżkę (wejście z listy i z karty).

Po siódme, historia ogranicza się do wykresu tygodnia. Potrzebne są zakresy 7 dni, 30 dni i 3 miesiące oraz lista przerw z przyczyną i czasem trwania (F6, scenariusz 4).

Po ósme, widok komunikacji kończy się na mapie i jednej linii. Alternatywne połączenie z porównaniem czasu i liczby przesiadek ma być dostępne w najwyżej dwóch krokach od statusu linii (F7, scenariusz 2).

Analiza TLM nie wskazuje na nadmiar kroków w ścieżkach, które makieta już realizuje (katalog, karta, grupy, wyciszenie, zatwierdzenie zgłoszenia). Poprawki powinny więc dodawać brakujące cele z GOMS i etykiety z przeglądu kognitywnego, a nie skracać istniejących sekwencji tapnięć.

## 5. Badania użyteczności

*TODO.*

## 6. Poprawa interfejsu

*TODO.*

## 7. Ponowne badania z użytkownikami

*TODO.*

## 8. Ocena użyteczności przez użytkowników

*TODO.*

## 9. Ocena użyteczności

*TODO.*
