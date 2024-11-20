#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда  

#Область СлужебныеПроцедурыИФункции 

Функция СоздатьСписокНаСервере(Знач ДатаНачала, Знач ДатаОкончания) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_Реализации
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка КАК Договор,
	|	ВТ_Реализации.Ссылка КАК Реализация,
	|	ДоговорыКонтрагентов.Владелец КАК Владелец,
	|	ДоговорыКонтрагентов.Организация КАК Организация,
	|	&ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	ВТ_Реализации КАК ВТ_Реализации
	|		ПРАВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО (ДоговорыКонтрагентов.Ссылка = ВТ_Реализации.Ссылка.Договор)
	|ГДЕ
	|	ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание)
	|	И ДоговорыКонтрагентов.ВКМ_ДатаНачалаДействияДоговора <= &ДатаНачала
	|	И ДоговорыКонтрагентов.ВКМ_ДатаОкончанияДействияДоговора >= &ДатаОкончания"; 
   	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();  
	
	СформированныйСписокРеализации =   СформироватьСписокРеализации(Выборка);  
	
	Возврат СформированныйСписокРеализации; 
		
КонецФункции // () 

Функция СформироватьСписокРеализации(Выборка)        
	
	СписокРеализацийМассив = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		СписокРеализацийСтруктура = Новый Структура; 
		Если Не ЗначениеЗаполнено(Выборка.Реализация) Тогда 
			НоваяРеализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент(); 
            НоваяРеализация.Дата = Выборка.ДатаОкончания;
			НоваяРеализация.Ответственный = Пользователи.ТекущийПользователь(); 
			НоваяРеализация.Договор = Выборка.Договор;    
	        НоваяРеализация.Контрагент = Выборка.Владелец; 
	        НоваяРеализация.Организация = Выборка.Организация; 
			НоваяРеализация.ВКМ_ВыполнитьАвтозаполнение();  
			НоваяРеализация.Записать(РежимЗаписиДокумента.Проведение,РежимПроведенияДокумента.Неоперативный); 
			//ВКМНачатьТранзакцию(НоваяРеализация); 
			СписокРеализацийСтруктура.Вставить("Договор", Выборка.Договор); 
			СписокРеализацийСтруктура.Вставить("Реализация", НоваяРеализация.Ссылка);
        Иначе 
			СписокРеализацийСтруктура.Вставить("Договор", Выборка.Договор); 
			СписокРеализацийСтруктура.Вставить("Реализация", Выборка.Реализация);	
		КонецЕсли; 
		СписокРеализацийМассив.Добавить(СписокРеализацийСтруктура); 
	КонецЦикла; 
	
	Возврат СписокРеализацийМассив; 

КонецФункции	
		
//Процедура	ВКМНачатьТранзакцию(НоваяРеализация); 
//	
//	НачатьТранзакцию(); 
//	Если НоваяРеализация.ПроверитьЗаполнение() Тогда
//		Попытка
//			НоваяРеализация.Записать(РежимЗаписиДокумента.Проведение,РежимПроведенияДокумента.Неоперативный); 
//        	ЗафиксироватьТранзакцию();
//		Исключение
//			ОтменитьТранзакцию();
//			Сообщить("Не удалось провести документ"); 
//			ЗаписьЖурналаРегистрации("ОБРАБОТКА: Массовое создание актов. Отмена проведения"); 
//		КонецПопытки;
//	Иначе 
//		Сообщить(СтрШаблон("Не удалось создать реализацию по Договору: %1. Не все обязательные данные заполнены", НоваяРеализация.Договор)); 
//	КонецЕсли;   

//КонецПроцедуры 

#КонецОбласти

#КонецЕсли
