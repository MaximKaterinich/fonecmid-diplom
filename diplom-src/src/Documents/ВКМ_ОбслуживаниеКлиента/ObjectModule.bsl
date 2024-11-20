
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда  
	
	#Область ОбработчикиСобытий
	
	Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты) 
		
		Если ВремяНачалаРабот >= ВремяОкончанияРабот Тогда  
			
			ОбщегоНазначения.СообщитьПользователю("Неверно задан период исполения заказа");
			
			Отказ = Истина; 
		КонецЕсли;     
		
		Если Дата <= Договор.ВКМ_ДатаНачалаДействияДоговора ИЛИ Дата >= Договор.ВКМ_ДатаОкончанияДействияДоговора Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Дата документа должна быть между началом и концом действия Договора";
			Сообщение.Поле = "Дата";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();     
			Отказ = Истина; 
		КонецЕсли;  
		
	КонецПроцедуры
	
	Процедура ОбработкаПроведения(Отказ, Режим)  
		
		ДвиженияВыполненныеКлиентуРаботы();     
		
		ДвиженияВыполненныеСотрудникомРаботы();   
		
	КонецПроцедуры 
	
	Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)     
		
		Запрос = Новый Запрос; 
		Запрос.Текст =   "ВЫБРАТЬ
		|	ВКМ_ОбслуживаниеКлиента.Клиент КАК Клиент,
		|	ВКМ_ОбслуживаниеКлиента.Специалист КАК Специалист,
		|	ВКМ_ОбслуживаниеКлиента.ДатаПроведенияРабот КАК ДатаПроведенияРабот,
		|	ВКМ_ОбслуживаниеКлиента.ВремяНачалаРабот КАК ВремяНачалаРабот,
		|	ВКМ_ОбслуживаниеКлиента.ВремяОкончанияРабот КАК ВремяОкончанияРабот,
		|	ВКМ_ОбслуживаниеКлиента.ОписаниеПроблемы КАК ОписаниеПроблемы
		|ИЗ
		|	Документ.ВКМ_ОбслуживаниеКлиента КАК ВКМ_ОбслуживаниеКлиента
		|ГДЕ
		|	ВКМ_ОбслуживаниеКлиента.Ссылка = &Ссылка"; 
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);   
		Выборка = Запрос.Выполнить().Выбрать();  
		Выборка.Следующий(); 	
		
		ТекстДляБота = СтрШаблон("Клиент: %1, Дата: %2, Время начала работ: %3, Время окончания работ: %4, Специалист: %5, ",  
		Строка(Клиент), Строка(Формат(ДатаПроведенияРабот, "ДЛФ=Д")), 
		Строка(Формат(ВремяНачалаРабот, "ДЛФ=В")), Строка(Формат(ВремяОкончанияРабот, "ДЛФ=В")), 
		Строка(Специалист)) + Строка(ОписаниеПроблемы);  
		
 		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			Если ЭтотОбъект.ЭтоНовый() Тогда  
				СоздатьНовоеУведомление(ТекстДляБота);   
			ИначеЕсли Не ЭтотОбъект.ЭтоНовый() Тогда       
				Если Выборка.Клиент <> Клиент Тогда
					ТекстКлиент = СтрШаблон("Клиент: %1. ", Клиент); 
				КонецЕсли;   
				Если Выборка.Специалист <> Специалист Тогда
					ТекстСпециалист = СтрШаблон("Специалист: %1. ", Специалист); 
				КонецЕсли;  
				Если Выборка.ДатаПроведенияРабот <> ДатаПроведенияРабот Тогда
					ТекстДатаРабот = СтрШаблон("Дата проведения работ: %1. ", Строка(Формат(ДатаПроведенияРабот, "ДЛФ=Д"))); 
				КонецЕсли; 
				Если Выборка.ВремяНачалаРабот <> ВремяНачалаРабот Тогда
					ТекстВремяНачала = СтрШаблон("Время начала работ: %1. ", Строка(Формат(ВремяНачалаРабот, "ДЛФ=В"))); 
				КонецЕсли;  
				Если Выборка.ВремяОкончанияРабот <> ВремяОкончанияРабот Тогда 
					ТекстВремениОкончания = СтрШаблон("Время окончания работ: %1 ", Строка(Формат(ВремяОкончанияРабот, "ДЛФ=В"))); 
				КонецЕсли;  
				Если Выборка.ОписаниеПроблемы <> ОписаниеПроблемы Тогда
					ТекстОписанияПроблемы = СтрШаблон("Описание проблемы: %1.", ОписаниеПроблемы); 
				КонецЕсли; 
				Преамбула = СтрШаблон("Изменились реквизиты %1. ", Ссылка); 
				ТекстДляБота = Преамбула + ТекстКлиент + ТекстСпециалист + ТекстДатаРабот
				+ ТекстВремяНачала + ТекстВремениОкончания + ТекстОписанияПроблемы; 	
				СоздатьНовоеУведомление(ТекстДляБота);  
			КонецЕсли; 
			
		КонецЕсли;   
		
	КонецПроцедуры   

	#КонецОбласти
	
	#Область СлужебныеПроцедурыФункции
	
	Процедура ДвиженияВыполненныеКлиентуРаботы()
		
		// регистр ВКМ_ВыполненныеКлиентуРаботы Приход
		Движения.ВКМ_ВыполненныеКлиентуРаботы.Записывать = Истина;
		Движение = Движения.ВКМ_ВыполненныеКлиентуРаботы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.Договор = Договор;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.ВКМ_СтоимостьЧасаРаботыСпециалиста КАК СтоимостьЧаса
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();     
		
		ВыборкаДетальныеЗаписи.Следующий(); 
		
		Движение.КоличествоЧасов = ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту");   
		Движение.СуммаКОплате = Движение.КоличествоЧасов * ВыборкаДетальныеЗаписи.СтоимостьЧаса;   
		
		Движения.ВКМ_ВыполненныеКлиентуРаботы.Записать();   
		
	КонецПроцедуры
	
	Процедура ДвиженияВыполненныеСотрудникомРаботы()
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|   ВКМ_УсловияОплатыСотрудниковСрезПоследних.ПроцентОтРабот КАК ПроцентОтРабот
		|ИЗ
		|   РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних(&Дата, ) КАК ВКМ_УсловияОплатыСотрудниковСрезПоследних
		|ГДЕ
		|   ВКМ_УсловияОплатыСотрудниковСрезПоследних.Сотрудник.Ссылка = &Сотрудник";
		
		Запрос.УстановитьПараметр("Дата", Дата);
		Запрос.УстановитьПараметр("Сотрудник", Специалист);
		
		РезультатЗапроса = Запрос.Выполнить(); 
		
		Если РезультатЗапроса.Пустой() Тогда
			Отказ = Истина;  
			Сообщить("Отсутствует значение процента от работы для указанного специалиста!"); 
			Возврат; 
		КонецЕсли;
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		ВыборкаДетальныеЗаписи.Следующий();
		
		Движения.ВКМ_ВыполненныеСотрудникомРаботы.Записывать = Истина; 
		Движение = Движения.ВКМ_ВыполненныеСотрудникомРаботы.Добавить(); 
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход; 
		Движение.Период = Дата; 
		Движение.Специалист = Специалист; 
		Движение.ЧасовКОплате = ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту");   
		
		ЧасовКОплатеКлиенту = ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту");   
		СтавкаЧасаКлиента = Договор.ВКМ_СтоимостьЧасаРаботыСпециалиста; 
		ПроцентОтРабот = ВыборкаДетальныеЗаписи.ПроцентОтРабот; 
		
		Движение.СуммаКОплате = ЧасовКОплатеКлиенту * СтавкаЧасаКлиента * ПроцентОтРабот / 100; 
		
		Движения.ВКМ_ВыполненныеСотрудникомРаботы.Записать(); 
		
	КонецПроцедуры
	
	Процедура СоздатьНовоеУведомление(ТекстДляБота) 
		
		НовыйЭлемент = Справочники.ВКМ_УведомленияТелеграмБоту.СоздатьЭлемент(); 
		НовыйЭлемент.ТекстСообщения = ТекстДляБота; 
		НовыйЭлемент.Записать();    
		
	КонецПроцедуры
	
	
	#КонецОбласти
	
#КонецЕсли



