# Файловые системы и LVM

Домашнее задания разработано для курса **[Administrator Linux. Professional](https://otus.ru/lessons/linux-professional/?int_source=courses_catalog&int_term=operations?utm_source=github&utm_medium=free&utm_campaign=otus)**

В рамках домашнего задания практически опробованы такие следующие приемы работы с LVM:
* изменение размера логического тома
* создание LVM mirror
* использование снэпшотов

А также в рамках дополнительного задания добавлена поддержка ZFS, собран пул с кэшированием, опробована работа со снэпшотами

В папке `scripts` собраны скрипты, реализующие выше описанное. После скриптов `01`, `02` подразумевается перезагрузка системы. В папке `capture` логи работы скриптов
```bash
sudo script -c <script_name>.sh <script_name>.script
```