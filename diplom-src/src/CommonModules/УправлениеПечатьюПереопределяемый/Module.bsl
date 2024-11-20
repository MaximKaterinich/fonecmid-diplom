///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет настройки подсистемы.
//
// Параметры:
//  Настройки - Структура:
//   * ИспользоватьПодписиИПечати - Булево - при установке значения Ложь отключается возможность установки подписей 
//                                           и печатей в печатных формах.
//   * СкрыватьПодписиИПечатиДляРедактирования - Булево - удалять рисунки подписей и печатей табличных документов при
//                                           снятии флажка "Подписи и печати" в форме "Печать документов", для того,
//                                           чтобы они не мешали редактировать текст, находящийся под ними.
//
Процедура ПриОпределенииНастроекПечати(Настройки) Экспорт

КонецПроцедуры

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.ЗаказПокупателя); 
    
    // ВКМ 01.02.24 {
    СписокОбъектов.Добавить(Документы.РеализацияТоваровУслуг); 
    // } ВКМ 01.02.24 
	
КонецПроцедуры

// Позволяет переопределить список команд печати в произвольной форме.
// Может использоваться для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. 
// Например, если в общих формах нужны специфические команды печати.
// Вызывается из функции УправлениеПечатью.КомандыПечатиФормы.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
// Пример:
//  Если ИмяФормы = "ОбщаяФорма.ЖурналДокументов" Тогда
//    Если Пользователи.РолиДоступны("ПечатьСчетаНаОплатуНаПринтер") Тогда
//      КомандаПечати = КомандыПечати.Добавить();
//      КомандаПечати.Идентификатор = "Счет";
//      КомандаПечати.Представление = НСтр("ru = 'Счет на оплату (на принтер)'");
//      КомандаПечати.Картинка = БиблиотекаКартинок.ПечатьСразу;
//      КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
//      КомандаПечати.СразуНаПринтер = Истина;
//    КонецЕсли;
//  КонецЕсли;
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Позволяет задать дополнительные настройки команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати:
//   * МенеджерКомандПечати     - ОбщийМодуль - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию - Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
//
// Пример:
//   Если НастройкиСписка.МенеджерКомандПечати = "ЖурналДокументов.СкладскиеДокументы" Тогда
//     НастройкиСписка.АвтоматическоеЗаполнение = Ложь;
//   КонецЕсли;
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
КонецПроцедуры

// Позволяет выполнить постобработку печатных форм при их формировании.
// Например, можно вставить в печатную форму дату формирования.
// Вызывается после завершения процедуры Печать менеджера печати объекта, имеет те же параметры.
// Не вызывается при вызове УправлениеПечатьюКлиент.ПечатьДокументов.
//
// Параметры:
//  МассивОбъектов - Массив из ЛюбаяСсылка - список объектов, для которых была выполняется команда печати;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - возвращаемый параметр, коллекция сформированных печатных форм:
//   * ИмяМакета - Строка - идентификатор печатной формы;
//   * СинонимМакета - Строка - название печатной формы;
//
//   * ТабличныйДокумент - ТабличныйДокумент - одна или несколько печатных форм, выведенных в один табличный документ
//                         Для разметки печатных форм внутри табличного документа после вывода каждой печатной формы
//                         необходимо вызывать процедуру УправлениеПечатью.ЗадатьОбластьПечатиДокумента;
//                         Параметр не используется, если вывод печатных форм выполняется в формате офисных документов
//                         (см. параметр "ОфисныеДокументы");
//
//   * ОфисныеДокументы - Соответствие из КлючИЗначение - коллекция печатных форм в формате офисных документов:
//                         ** Ключ - Строка - адрес во временном хранилище двоичных данных печатной формы;
//                         ** Значение - Строка - имя файла печатной формы.
//
//   * ИмяФайлаПечатнойФормы - Строка - имя файла печатной формы при сохранении в файл или отправке в качестве
//                                      почтового вложения. Не используется для печатных форм в формате офисных документов.
//                                      По умолчанию имя файла устанавливается в формате
//                                      "[НазваниеПечатнойФормы] № [Номер] от [Дата]" для документов,
//                                      "[НазваниеПечатнойФормы] - [ПредставлениеОбъекта] - [ТекущаяДата]" для объектов.
//                           - Соответствие из КлючИЗначение - имена файлов для каждого объекта:
//                              ** Ключ - ЛюбаяСсылка - ссылка на объект печати из коллекции МассивОбъектов;
//                              ** Значение - Строка - имя файла;
//
//   * Экземпляров - Число - количество копий, которое необходимо вывести на печать;
//   * ПолныйПутьКМакету - Строка - используется для быстрого перехода к редактированию макета печатной формы
//                                  в общей форме ПечатьДокументов;
//   * ДоступенВыводНаДругихЯзыках - Булево - необходимо установить значение Истина, если печатная форма адаптирована
//                                            для вывода на произвольном языке.
//  
//  ОбъектыПечати - СписокЗначений - выходной параметр, соответствие между объектами и именами областей в табличных
//                                   документах, заполняется автоматически
//                                   при вызове УправлениеПечатью.ЗадатьОбластьПечатиДокумента:
//   * Значение - ЛюбаяСсылка - ссылка из коллекции МассивОбъектов,
//   * Представление - Строка - имя области с объектом в табличных документах;
//
//  ПараметрыВывода - Структура - настройки вывода печатных форм:
//   * ПараметрыОтправки - Структура - для автоматического заполнения полей в форме создания письма при отправке 
//                                     сформированных печатных форм по почте:
//     ** Получатель - см. РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма.Получатель
//     ** Тема       - см. РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма.Тема
//     ** Текст      - см. РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма.Текст
//   * КодЯзыка - Строка - язык, на котором требуется сформировать печатную форму.
//                         Состоит из кода языка по ISO 639-1 и, опционально, кода страны по ISO 3166-1, разделенных
//                         символом подчеркивания. Примеры: "en", "en_US", "en_GB", "ru", "ru_RU".
//
//   * ЗаголовокФормы - Строка - переопределяет заголовок формы печати документов (ПечатьДокументов).
//
// Пример:
//
//  ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "<ИдентификаторПечатнойФормы>");
//  Если ПечатнаяФорма <> Неопределено Тогда
//    ТабличныйДокумент = Новый ТабличныйДокумент;
//    ТабличныйДокумент.КлючПараметровПечати = "<КлючСохраненияПараметровПечатнойФормы>";
//    Для Каждого Ссылка Из МассивОбъектов Цикл
//      Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
//        ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
//      КонецЕсли;
//      НачалоОбласти = ТабличныйДокумент.ВысотаТаблицы + 1;
//      // ... код по формированию табличного документа ...
//      УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НачалоОбласти, ОбъектыПечати, Ссылка);
//    КонецЦикла;
//    ПечатнаяФорма.ТабличныйДокумент = ТабличныйДокумент;
//  КонецЕсли;
//
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатная форма.
//
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
	
	
КонецПроцедуры

// Определяет набор подписей и печатей для документов.
//
// Параметры:
//  Документы      - Массив    - коллекция ссылок на объекты печати;
//  ПодписиИПечати - Соответствие из КлючИЗначение - коллекция объектов печати и комплектов подписей/печатей к ним:
//   * Ключ     - ЛюбаяСсылка - ссылка на объект печати;
//   * Значение - Структура   - комплект подписей и печатей:
//     ** Ключ     - Строка - идентификатор подписи или печати в макете печатной формы, 
//                            должен начинаться с "Подпись...", "Печать..." или "Факсимиле...",
//                            например, "ПодписьРуководителя", "ПечатьОрганизации";
//     ** Значение - Картинка - изображение подписи или печати.
//
Процедура ПриПолученииПодписейИПечатей(Документы, ПодписиИПечати) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из обработчика ПриСозданииНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет изменить внешний вид и поведение формы, например, разместить на ней дополнительные элементы:
// информационные надписи, кнопки, гиперссылки, различные настройки и т.п.
//
// При добавлении команд (кнопок) в качестве обработчика следует указывать имя "Подключаемый_ВыполнитьКоманду",
// а его реализацию размещать в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриВыполненииКоманды (серверная часть),
// либо в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду (клиентская часть).
//
// Для того, чтобы добавить свою команду на форму, необходимо сделать следующее.
// 1. Создать команду и кнопку в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриСозданииНаСервере.
// 2. Реализовать клиентский обработчик команды в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду.
// 3. (Опционально) Реализовать серверный обработчик команды в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриВыполненииКоманды.
//
// При добавлении гиперссылок в качестве обработчика нажатия следует указывать имя "Подключаемый_ОбработкаНавигационнойСсылки",
// а его реализацию размещать в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовОбработкаНавигационнойСсылки.
//
// При размещении элементов, значение которых должны запоминаться между открытиями формы печати,
// следует воспользоваться процедурами ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере и
// ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Отказ                - Булево - признак отказа от создания формы. Если установить
//                                  данному параметру значение Истина, то форма создана не будет.
//  СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения стандартной (системной) обработки
//                                  события. Если установить данному параметру значение Ложь, 
//                                  стандартная обработка события производиться не будет.
// 
// Пример:
//  КомандаФормы = Форма.Команды.Добавить("МояКоманда");
//  КомандаФормы.Действие = "Подключаемый_ВыполнитьКоманду";
//  КомандаФормы.Заголовок = НСтр("ru = 'Моя команда'");
//  
//  КнопкаФормы = Форма.Элементы.Добавить(КомандаФормы.Имя, Тип("КнопкаФормы"), Форма.Элементы.КоманднаяПанельПраваяЧасть);
//  КнопкаФормы.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
//  КнопкаФормы.ИмяКоманды = КомандаФормы.Имя;
//
Процедура ПечатьДокументовПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из обработчика ПриЗагрузкеДанныхИзНастроекНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Совместно с ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере позволяет реализовать загрузку и сохранение 
// настроек элементов управления, размещенных с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма     - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Настройки - Соответствие     - значения реквизитов формы.
//
Процедура ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере(Форма, Настройки) Экспорт
	
КонецПроцедуры

// Вызывается из обработчика ПриСохраненииДанныхВНастройкахНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Совместно с ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере позволяет реализовать загрузку и сохранение 
// настроек элементов управления, размещенных с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма     - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Настройки - Соответствие     - значения реквизитов формы.
//
Процедура ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере(Форма, Настройки) Экспорт

КонецПроцедуры

// Вызывается из обработчика Подключаемый_ВыполнитьКоманду формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет реализовать серверную часть обработчика команды, которая добавлена в форму 
// с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  ДополнительныеПараметры - Произвольный     - параметры, переданные из УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду.
//
// Пример:
//  Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") И ДополнительныеПараметры.ИмяКоманды = "МояКоманда" Тогда
//   ТабличныйДокумент = Новый ТабличныйДокумент;
//   ТабличныйДокумент.Область("R1C1").Текст = НСтр("ru = 'Пример использования серверного обработчика подключенной команды.'");
//  
//   ПечатнаяФорма = Форма[ДополнительныеПараметры.ИмяРеквизитаТабличногоДокумента];
//   ПечатнаяФорма.ВставитьОбласть(ТабличныйДокумент.Область("R1"), ПечатнаяФорма.Область("R1"), 
//    ТипСмещенияТабличногоДокумента.ПоГоризонтали)
//  КонецЕсли;
//
Процедура ПечатьДокументовПриВыполненииКоманды(Форма, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Определяет используемый макет данных печати объектов метаданных и их полей.
//
// Параметры:
//  Объект - Строка - полное имя объекта метаданных либо имя поля из макета "ДанныеПечати" объекта метаданных
//                      в формате "ПолноеИмяОбъектаМетаданных.ИмяПоля".
//  ИсточникиДанныхПечати - СписокЗначений:
//    * Значение - СхемаКомпоновкиДанных - схемы данных печати.
//    * Представление - Строка - идентификатор схемы, используется при получении данных.
//    * Пометка -Булево - Истина, если в качестве дополнительного ключевого поля выступает владелец источника данных.
//
Процедура ПриОпределенииИсточниковДанныхПечати(Объект, ИсточникиДанныхПечати) Экспорт
	
	
	
КонецПроцедуры

// Подготавливает данные печати.
//
// Параметры:
//  ИсточникиДанных - Массив - объекты, для которых формируются данные печати.
//  ВнешниеНаборыДанных - Структура - коллекция наборов данных для передачи в процессор компоновки данных.
//  ИдентификаторСхемыКомпоновкиДанных - Строка - идентификатор СКД, указанный в ПриОпределенииИсточниковДанныхПечати.
//  КодЯзыка - Строка - язык, на котором требуется подготовить данные печати.
//  ДополнительныеПараметры - Структура:
//   * ОписанияИсточниковДанных - ТаблицаЗначений - дополнительные сведения об объектах, для которых формируются данные печати.
//   * ДанныеИсточниковСгруппированыПоВладельцуИсточникаДанных - Булево - указывает на то, что в результате компоновки
//                           данные печати сгруппированы не по объектам печати, а по их владельцам в схеме данных печати.
//  
Процедура ПриПодготовкеДанныхПечати(ИсточникиДанных, ВнешниеНаборыДанных, ИдентификаторСхемыКомпоновкиДанных, КодЯзыка,
	ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
