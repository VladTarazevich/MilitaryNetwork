-- 1-6 ПУНКТЫ ЗАДАЧИ
USE master; 
DROP DATABASE IF EXISTS MilitaryNetwork; 
CREATE DATABASE MilitaryNetwork; 
GO
USE MilitaryNetwork;
GO

-- 1 ПУНКТ ЗАДАЧИ
CREATE TABLE MilitaryFormation -- Воинское подразделение
( 
id INT NOT NULL PRIMARY KEY,  
name NVARCHAR(50) NOT NULL 
) AS NODE;

CREATE TABLE FederalSubject  -- Административный регион
( 
id INT NOT NULL PRIMARY KEY,  
name NVARCHAR(50) NOT NULL,  
MilitaryDistrict NVARCHAR(50) NOT NULL -- Военный округ, обьединяющий регионы
) AS NODE;

CREATE TABLE MilitaryInstallation -- Воинская часть  
( 
id INT NOT NULL PRIMARY KEY,  
name NVARCHAR(50) NOT NULL,  
FederalSubject NVARCHAR(30) NOT NULL 
) AS NODE;

-- 2 ПУНКТ ЗАДАЧИ
CREATE TABLE ReportsTo AS EDGE; -- Связь подотчётности одного воинского подразделения другому
CREATE TABLE HeadQuarteredIn AS EDGE; -- Связь Штаб воинского подразделения находится  в федеральном субъекте
CREATE TABLE StationedIn AS EDGE; --  Связь воинская часть находится в Федеральный субъекте
CREATE TABLE HasComponent (MiniFormationsCount INT) AS EDGE; -- Связь часть воинского подразделения нахождится в воинской части в количестве N малых подразделений

ALTER TABLE ReportsTo  
ADD CONSTRAINT EC_ReportsTo CONNECTION (MilitaryFormation TO MilitaryFormation);
ALTER TABLE HeadQuarteredIn  
ADD CONSTRAINT EC_HeadQuarteredIn CONNECTION (MilitaryFormation TO FederalSubject); 
ALTER TABLE StationedIn  
ADD CONSTRAINT EC_StationedIn CONNECTION (MilitaryInstallation TO FederalSubject); 
ALTER TABLE HasComponent  
ADD CONSTRAINT EC_HasComponent CONNECTION (MilitaryFormation TO MilitaryInstallation); 
GO

-- 3 ПУНКТ ЗАДАЧИ
INSERT INTO MilitaryFormation (id, name)  
VALUES (1, N'4-я гвардейская танковая армия'),  
(2, N'7-я гвардейская мотострелковая бригада'),  
(3, N'27-я отдельная мотострелковая бригада'),  
(4, N'22-й гвардейский истребительный авиаполк'),  
(5, N'15-я зенитно-ракетная дивизия (ПВО)'),  
(6, N'Балтийский флот (основное соединение)'),  
(7, N'Мурманское подводное ядерное соединение'),  
(8, N'31-я ракетная армия'),
(9, N'76-я гвардейская десантно-штурмовая дивизия'),
(10, N'10-я бригада спецназа ГРУ');
GO 

INSERT INTO FederalSubject (id, name, militaryDistrict)  
VALUES 
(1, N'Калининградская область', N'Западный военный округ'),  
(2, N'Ленинградская область', N'Западный военный округ'),  
(3, N'Ростовская область', N'Южный военный округ'),  
(4, N'Краснодарский край', N'Южный военный округ'),  
(5, N'Московская область', N'Центральный военный округ'),  
(6, N'Свердловская область', N'Центральный военный округ'),  
(7, N'Приморский край', N'Восточный военный округ'),  
(8, N'Хабаровский край', N'Восточный военный округ'),  
(9, N'Мурманская область', N'Северный флот (отдельный округ)'),  
(10, N'Архангельская область', N'Северный флот (отдельный округ)');  
GO

INSERT INTO MilitaryInstallation (id, name, federalSubject)  
VALUES 
(1, N'В/Ч 71432 (Балтийск)', N'Калининградская область'),  
(2, N'Авиабаза "Бесовец"', N'Ленинградская область'),  
(3, N'Танковый полк "Донской"', N'Ростовская область'),  
(4, N'В/Ч 35690 (Новороссийск)', N'Краснодарский край'),  
(5, N'Ракетная база "Клин"', N'Московская область'),  
(6, N'Уральский арсенал (г. Екатеринбург)', N'Свердловская область'),  
(7, N'ТОФ база "Владивосток"', N'Приморский край'),  
(8, N'Вертолётная база "Хабаровск-Центральный"', N'Хабаровский край'),  
(9, N'Севморбаза "Североморск"', N'Мурманская область'),  
(10, N'Космодром "Плесецк"', N'Архангельская область');  
GO  

--4 ПУНКТ ЗАДАЧИ
INSERT INTO StationedIn ($from_id, $to_id) 
VALUES ((SELECT $node_id FROM MilitaryInstallation WHERE ID = 1),  
(SELECT $node_id FROM FederalSubject WHERE ID = 1)), 
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 2),  
(SELECT $node_id FROM FederalSubject WHERE ID = 2)), 
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 3),  
(SELECT $node_id FROM FederalSubject WHERE ID = 3)), 
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 4),  
(SELECT $node_id FROM FederalSubject WHERE ID = 4)),
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 5),  
(SELECT $node_id FROM FederalSubject WHERE ID = 5)),
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 6),  
(SELECT $node_id FROM FederalSubject WHERE ID = 6)),
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 7),  
(SELECT $node_id FROM FederalSubject WHERE ID = 7)),
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 8),  
(SELECT $node_id FROM FederalSubject WHERE ID = 8)),
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 9),  
(SELECT $node_id FROM FederalSubject WHERE ID = 9)),
((SELECT $node_id FROM MilitaryInstallation WHERE ID = 10),  
(SELECT $node_id FROM FederalSubject WHERE ID = 10));
GO

INSERT INTO ReportsTo ($from_id, $to_id) 
VALUES ((SELECT $node_id FROM MilitaryFormation WHERE id = 10),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 5)), 
((SELECT $node_id FROM MilitaryFormation WHERE id = 10),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 9)), 
((SELECT $node_id FROM MilitaryFormation WHERE id = 5),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 8)), 
((SELECT $node_id FROM MilitaryFormation WHERE id = 9),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 2)), 
((SELECT $node_id FROM MilitaryFormation WHERE id = 2),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 1)),        
((SELECT $node_id FROM MilitaryFormation WHERE id = 3),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 1)), 
((SELECT $node_id FROM MilitaryFormation WHERE id = 4),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 2)),  
((SELECT $node_id FROM MilitaryFormation WHERE id = 4),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 6)), 
((SELECT $node_id FROM MilitaryFormation WHERE id = 6),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 7)), 
((SELECT $node_id FROM MilitaryFormation WHERE id = 7),  
(SELECT $node_id FROM MilitaryFormation WHERE id = 8)); 
GO 

INSERT INTO HeadQuarteredIn ($from_id, $to_id) 
VALUES ((SELECT $node_id FROM MilitaryFormation WHERE ID = 1),  
(SELECT $node_id FROM FederalSubject WHERE ID = 2)), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 2),  
(SELECT $node_id FROM FederalSubject WHERE ID = 1)), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 3),  
(SELECT $node_id FROM FederalSubject WHERE ID = 3)), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 4),  
(SELECT $node_id FROM FederalSubject WHERE ID = 8)), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 5),  
(SELECT $node_id FROM FederalSubject WHERE ID = 6)), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 6),  
(SELECT $node_id FROM FederalSubject WHERE ID = 4)), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 7),  
(SELECT $node_id FROM FederalSubject WHERE ID = 9)), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 8),  
(SELECT $node_id FROM FederalSubject WHERE ID = 5)),
((SELECT $node_id FROM MilitaryFormation WHERE ID = 9),  
(SELECT $node_id FROM FederalSubject WHERE ID = 7)),
((SELECT $node_id FROM MilitaryFormation WHERE ID = 10),  
(SELECT $node_id FROM FederalSubject WHERE ID = 10)); 
GO

INSERT INTO HasComponent ($from_id, $to_id, MiniFormationsCount) 
VALUES ((SELECT $node_id FROM MilitaryFormation WHERE ID = 2),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 1), 8), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 1),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 2), 40), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 3),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 3), 7), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 6),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 4), 34), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 8),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 5), 13), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 5),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 6), 24), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 9),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 6), 5), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 7), 
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 9), 9), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 10),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 10), 3), 
((SELECT $node_id FROM MilitaryFormation WHERE ID = 4),  
(SELECT $node_id FROM MilitaryInstallation WHERE ID = 8), 32);
GO

-- 5 ПУНКТ ЗАДАЧИ
-- Кому подотчётна 10-я бригада спецназа ГРУ?
SELECT MilitaryFormation1.name 
, MilitaryFormation2.name AS [reportFormation name] 
FROM MilitaryFormation     
AS MilitaryFormation1 
, ReportsTo 
, MilitaryFormation   
AS MilitaryFormation2 
WHERE MATCH(MilitaryFormation1-(ReportsTo)->MilitaryFormation2) 
AND MilitaryFormation1.name = N'10-я бригада спецназа ГРУ'; 

-- Кому отчитываются подразделения, которым подотчётен 22-й гвардейский истребительный авиаполк?
SELECT MilitaryFormation1.name + N' отчитывается подразделению ' + MilitaryFormation2.name AS Level1 
, MilitaryFormation2.name + N' отчитывается подразделению ' + MilitaryFormation3.name AS Level2 
FROM MilitaryFormation     
AS MilitaryFormation1 
, ReportsTo AS reportFormation1 
, MilitaryFormation   
AS MilitaryFormation2 
, ReportsTo AS reportFormation2 
, MilitaryFormation   
AS MilitaryFormation3 
WHERE MATCH(MilitaryFormation1-(reportFormation1)->MilitaryFormation2-(reportFormation2)->MilitaryFormation3) 
AND MilitaryFormation1.name = N'22-й гвардейский истребительный авиаполк'; 

-- На каких базах находятся подразделения, которым отчитывается 22-й гвардейский истребительный авиаполк?
SELECT MilitaryFormation2.name AS MilitaryFormation 
, MilitaryInstallation.name AS militaryInstallation 
, HasComponent.MiniFormationsCount 
FROM MilitaryFormation   
AS MilitaryFormation1 
, MilitaryFormation AS MilitaryFormation2 
, HasComponent 
, ReportsTo 
, MilitaryInstallation 
WHERE MATCH(MilitaryFormation1-(ReportsTo)->MilitaryFormation2-(HasComponent)->MilitaryInstallation) 
AND MilitaryFormation1.name = N'22-й гвардейский истребительный авиаполк'; 

-- На каких базах и в каком количестве малых подразделений находятся подразделения, которым подотчётны силы, которым отчитывается 10-я бригада спецназа ГРУ?
SELECT MilitaryFormation3.name AS MilitaryFormation 
, MilitaryInstallation.name AS militaryInstallation 
, HasComponent.MiniFormationsCount 
FROM MilitaryFormation   
AS MilitaryFormation1 
, MilitaryFormation AS MilitaryFormation2 
, MilitaryFormation AS MilitaryFormation3 
, HasComponent 
, ReportsTo AS ReportsTo1 
, ReportsTo AS ReportsTo2 
, MilitaryInstallation 
WHERE MATCH(MilitaryFormation1-(ReportsTo1)->MilitaryFormation2-(ReportsTo2)->MilitaryFormation3-(HasComponent)->MilitaryInstallation)
AND MilitaryFormation1.name = N'10-я бригада спецназа ГРУ'; 

-- Какие подразделения имеют в одном федеральном субъекте и штаб, и часть своих сил?
SELECT MilitaryFormation.name AS militaryFormation 
, MilitaryInstallation.name AS militaryInstallation 
, HasComponent.MiniFormationsCount  
, FederalSubject.name AS federalSubject 
FROM MilitaryFormation 
, HasComponent 
, MilitaryInstallation 
, HeadQuarteredIn 
, FederalSubject 
, StationedIn 
WHERE MATCH (MilitaryFormation-(HasComponent)->MilitaryInstallation-(StationedIn)->FederalSubject  
AND MilitaryFormation-(HeadQuarteredIn)->FederalSubject)

select * from militaryformation
-- 6 ПУНКТ ЗАДАЧИ
-- Максимально возможная сеть отчётности для 10-я бригады спецназа ГРУ
SELECT MilitaryFormation1.name AS MilitaryFormationName  
, STRING_AGG(MilitaryFormation2.name, '->') WITHIN GROUP (GRAPH PATH) AS 
ReportFormations 
FROM   MilitaryFormation AS MilitaryFormation1 
, ReportsTo FOR PATH AS rt 
, MilitaryFormation FOR PATH  AS MilitaryFormation2 
WHERE  MATCH(SHORTEST_PATH(MilitaryFormation1(-(rt)->MilitaryFormation2)+)) 
AND MilitaryFormation1.name = N'10-я бригада спецназа ГРУ';

-- Самый быстрый способ донести отчёт
DECLARE @MilitaryFormationFrom AS NVARCHAR(50) = N'22-й гвардейский истребительный авиаполк'; 
DECLARE @MilitaryFormationTo   
AS NVARCHAR(50) = N'31-я ракетная армия'; 
WITH T1 AS 
( 
SELECT MilitaryFormation1.name AS MilitaryFormationName  
, STRING_AGG(MilitaryFormation2.name, '->') WITHIN GROUP (GRAPH PATH) 
AS ReportFormations 
, LAST_VALUE(MilitaryFormation2.name) WITHIN GROUP (GRAPH PATH) AS 
LastNode 
FROM   MilitaryFormation AS MilitaryFormation1 
, ReportsTo FOR PATH AS rt 
, MilitaryFormation FOR PATH  AS MilitaryFormation2 
WHERE  MATCH(SHORTEST_PATH(MilitaryFormation1(-(rt)->MilitaryFormation2)+)) 
AND MilitaryFormation1.name = @MilitaryFormationFrom 
) 
SELECT MilitaryFormationName, ReportFormations 
FROM T1 
WHERE LastNode = @MilitaryFormationTo;

-- 0 ПУНКТ УДАЛЕНИЕ ДАННЫХ
DELETE FROM ReportsTo 
GO
DELETE FROM HeadQuarteredIn 
GO
DELETE FROM HasComponent 
GO
DELETE FROM MilitaryFormation 
GO
DELETE FROM StationedIn 
GO
DELETE FROM FederalSubject
GO
DELETE FROM MilitaryInstallation 
GO
