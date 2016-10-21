# PRZEDŁUŻACZ ZASIĘGU PILOTA RTV OPARTY O TRANSMISJĘ WI-FI #

Tematem jest zaprojektowanie i wykonanie urządzenia, którego zadaniem będzie umożliwienie kontroli sprzętu RTV (elektroniki użytkowej) posiadającego port podczerwieni, za pomocą pilota podczerwieni znajdującego się w dużej odległości od odbiornika lub będącego za przeszkodami nieprzenikliwymi dla wiązki światła. Głównym problemem, który urządzenie to ma za zadanie rozwiązać, jest zasięg pilotów podczerwieni. Wiązka podczerwieni jest zwykle zbyt słaba, aby kontrolować odbiorniki RTV na dużą odległość. Nie przenika ona także przez elementy takie jak ściany, meble. 
Dodatkową funkcjonalnością może być możliwość kontroli sprzętu RTV za pomocą urządzeń posiadających możliwość komunikacji Wi-Fi. Pozwoli to na kontrolę zarówno nowych, jak i starych urządzeń RTV (m.in. telewizory, odtwarzacze audio, odtwarzacze DVD) za pomocą jednego urządzenia o dużym zasięgu i rozszerzy jednocześnie możliwości interakcji ze sprzętem RTV. Będzie ono składać się z podzespołów tanich, szeroko dostępnych oraz będzie łatwe do złożenia. 
Motywem do zbudowania tego typu urządzenia jest dla mnie fakt, że w większości gospodarstw domowych pojawia się coraz więcej urządzeń kontrolowanych za pomocą pilota a także, co za tym idzie, coraz więcej pilotów. Należy mieć je wszystkie w pobliżu, aby móc wygodnie użytkować różnorodny sprzęt. Użytkownik tych urządzeń musi także dbać o niezakłóconą linię komunikacyjną podczerwieni między pilotem a odbiornikiem. W pewnych sytuacjach jest to bardzo utrudnione, na przykład przez konstrukcję mebli lub przedmioty ustawione przed odbiornikiem. 
Zdarza się też, że jakość komunikacji w podczerwieni spada z czasem przez zużycie odbiornika lub pilota, a co za tym idzie, maleje także zasięg. Rozwiązaniem powyższych problemów byłby właśnie przedłużacz zasięgu pilota oparty o transmisję Wi-Fi. 

Urządzenie ma na celu odbiór kodów podczerwieni z pilota, transmisję kodu po Wi-Fi na pewną odległość, a następnie wysłanie danych przez transmisję w podczerwieni do urządzenia RTV. Musi zatem składać się z dwóch części: odbiorczej podczerwieni - nadawczej Wi-Fi oraz odbiorczej Wi-Fi - nadawczej podczerwieni. Każda z tych części posiadać musi element komunikacyjny podczerwieni, element przetwarzający dane oraz element komunikacyjny Wi-Fi. 
Elementem komunikacyjnym podczerwieni w przypadku części pierwszej urządzenia będzie odbiornik podczerwieni, w przypadku części drugiej będzie to nadajnik podczerwieni. Elementem przetwarzającym dane zostanie mikrokontroler, ponieważ nie są w tym zastosowaniu potrzebne duże moce obliczeniowe. Stanie się on jednostką centralną urządzenia. Elementem komunikacyjnym Wi-Fi w obu przypadkach będzie podobny moduł Wi-Fi obsługujący nadawanie informacji i jej odbiór. Połączenia w przypadku obu części urządzenia sprowadzą się do podłączenia wszystkich elementów komunikacyjnych w danej części do mikrokontrolera zarządzającego komunikacją pomiędzy elementem podczerwieni a modułem Wi-Fi. Dwie części urządzenia komunikować się będą poprzez Wi-Fi. Istniała też będzie możliwość połączenia urządzenia typu PC/telefon poprzez Wi-Fi do części urządzenia nadającej IR oraz połączenie urządzenia z routerem Wi-Fi, aby kontrolować nadawanie sygnałów podczerwieni z poziomu bezprzewodowej sieci lokalnej.

Proof of concept device:

![proof of concept device](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2014-10-27-637%20%E2%80%94%20opisane.jpg)

Arduino code for client and server IR uC:

![code in arduino](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2014-10-27-635.jpg)

Helper device (displays received IR codes on LCD):

![helper device](https://raw.githubusercontent.com/michal2229/Przedluzacz-Pilota-IR-po-WiFi/master/dodatkowe%20materialy/zdjecia/2014-10-26-632.jpg)
