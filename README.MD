# Как запустить?
 1. Склонировать проект
 2. Выбрать схему searchMedia и запустить
 
# Что было реализовано:

## Общие требования
 Реализованы все требования

## Экран поиска
 Реализованы все требования. История поиска сохраняется в UserDefaults, есть подсказки, фильтрация. UI в виде "плиток".
 Дополнительно: Реализована возможность изменять значнеия, которые уходят в API.
 
## Экран с детальной информацией
 Реализованы все требования, есть запрос с детальной информацией об авторе и гиперссылка на автора.
 
## Дополнительно
 Отсутствие подвисаний (hitches, hangs) при скроле поисковой выдачи, у каждого экрана есть три состоянии (загрузка, ошибка и контент). Элементы не показываются на экране, если нет для них информации.
 Приложение написано на Swift, без использования библиотек. 
 Интерфейс реализован польностью кодом на UIKit (без SwiftUI).
 Для сетевых запросов используется URLSession.
 
 
