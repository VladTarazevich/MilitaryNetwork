-- 1-6 ������ ������
USE master; 
DROP DATABASE IF EXISTS MilitaryNetwork; 
CREATE DATABASE MilitaryNetwork; 
GO
USE MilitaryNetwork;
GO

-- 1 ����� ������
CREATE TABLE MilitaryFormation -- �������� �������������
( 
id INT NOT NULL PRIMARY KEY,  
name NVARCHAR(50) NOT NULL 
) AS NODE;

CREATE TABLE FederalSubject  -- ���������������� ������
( 
id INT NOT NULL PRIMARY KEY,  
name NVARCHAR(50) NOT NULL,  
MilitaryDistrict NVARCHAR(50) NOT NULL -- ������� �����, ������������ �������
) AS NODE;

CREATE TABLE MilitaryInstallation -- �������� �����  
( 
id INT NOT NULL PRIMARY KEY,  
name NVARCHAR(50) NOT NULL,  
FederalSubject NVARCHAR(30) NOT NULL 
) AS NODE;

-- 2 ����� ������
CREATE TABLE ReportsTo AS EDGE; -- ����� ������������� ������ ��������� ������������� �������
CREATE TABLE HeadQuarteredIn AS EDGE; -- ����� ���� ��������� ������������� ���������  � ����������� ��������
CREATE TABLE StationedIn AS EDGE; --  ����� �������� ����� ��������� � ����������� ��������
CREATE TABLE HasComponent (MiniFormationsCount INT) AS EDGE; -- ����� ����� ��������� ������������� ���������� � �������� ����� � ���������� N ����� �������������

ALTER TABLE ReportsTo  
ADD CONSTRAINT EC_ReportsTo CONNECTION (MilitaryFormation TO MilitaryFormation);
ALTER TABLE HeadQuarteredIn  
ADD CONSTRAINT EC_HeadQuarteredIn CONNECTION (MilitaryFormation TO FederalSubject); 
ALTER TABLE StationedIn  
ADD CONSTRAINT EC_StationedIn CONNECTION (MilitaryInstallation TO FederalSubject); 
ALTER TABLE HasComponent  
ADD CONSTRAINT EC_HasComponent CONNECTION (MilitaryFormation TO MilitaryInstallation); 
GO

-- 3 ����� ������
INSERT INTO MilitaryFormation (id, name)  
VALUES (1, N'4-� ����������� �������� �����'),  
(2, N'7-� ����������� �������������� �������'),  
(3, N'27-� ��������� �������������� �������'),  
(4, N'22-� ����������� �������������� ��������'),  
(5, N'15-� �������-�������� ������� (���)'),  
(6, N'���������� ���� (�������� ����������)'),  
(7, N'���������� ��������� ������� ����������'),  
(8, N'31-� �������� �����'),
(9, N'76-� ����������� ��������-��������� �������'),
(10, N'10-� ������� �������� ���');
GO 

INSERT INTO FederalSubject (id, name, militaryDistrict)  
VALUES 
(1, N'��������������� �������', N'�������� ������� �����'),  
(2, N'������������� �������', N'�������� ������� �����'),  
(3, N'���������� �������', N'����� ������� �����'),  
(4, N'������������� ����', N'����� ������� �����'),  
(5, N'���������� �������', N'����������� ������� �����'),  
(6, N'������������ �������', N'����������� ������� �����'),  
(7, N'���������� ����', N'��������� ������� �����'),  
(8, N'����������� ����', N'��������� ������� �����'),  
(9, N'���������� �������', N'�������� ���� (��������� �����)'),  
(10, N'������������� �������', N'�������� ���� (��������� �����)');  
GO

INSERT INTO MilitaryInstallation (id, name, federalSubject)  
VALUES 
(1, N'�/� 71432 (��������)', N'��������������� �������'),  
(2, N'�������� "�������"', N'������������� �������'),  
(3, N'�������� ���� "�������"', N'���������� �������'),  
(4, N'�/� 35690 (������������)', N'������������� ����'),  
(5, N'�������� ���� "����"', N'���������� �������'),  
(6, N'��������� ������� (�. ������������)', N'������������ �������'),  
(7, N'��� ���� "�����������"', N'���������� ����'),  
(8, N'���������� ���� "���������-�����������"', N'����������� ����'),  
(9, N'���������� "�����������"', N'���������� �������'),  
(10, N'��������� "�������"', N'������������� �������');  
GO  

--4 ����� ������
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

-- 5 ����� ������
-- ���� ���������� 10-� ������� �������� ���?
SELECT MilitaryFormation1.name 
, MilitaryFormation2.name AS [reportFormation name] 
FROM MilitaryFormation     
AS MilitaryFormation1 
, ReportsTo 
, MilitaryFormation   
AS MilitaryFormation2 
WHERE MATCH(MilitaryFormation1-(ReportsTo)->MilitaryFormation2) 
AND MilitaryFormation1.name = N'10-� ������� �������� ���'; 

-- ���� ������������ �������������, ������� ���������� 22-� ����������� �������������� ��������?
SELECT MilitaryFormation1.name + N' ������������ ������������� ' + MilitaryFormation2.name AS Level1 
, MilitaryFormation2.name + N' ������������ ������������� ' + MilitaryFormation3.name AS Level2 
FROM MilitaryFormation     
AS MilitaryFormation1 
, ReportsTo AS reportFormation1 
, MilitaryFormation   
AS MilitaryFormation2 
, ReportsTo AS reportFormation2 
, MilitaryFormation   
AS MilitaryFormation3 
WHERE MATCH(MilitaryFormation1-(reportFormation1)->MilitaryFormation2-(reportFormation2)->MilitaryFormation3) 
AND MilitaryFormation1.name = N'22-� ����������� �������������� ��������'; 

-- �� ����� ����� ��������� �������������, ������� ������������ 22-� ����������� �������������� ��������?
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
AND MilitaryFormation1.name = N'22-� ����������� �������������� ��������'; 

-- �� ����� ����� � � ����� ���������� ����� ������������� ��������� �������������, ������� ���������� ����, ������� ������������ 10-� ������� �������� ���?
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
AND MilitaryFormation1.name = N'10-� ������� �������� ���'; 

-- ����� ������������� ����� � ����� ����������� �������� � ����, � ����� ����� ���?
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
-- 6 ����� ������
-- ����������� ��������� ���� ���������� ��� 10-� ������� �������� ���
SELECT MilitaryFormation1.name AS MilitaryFormationName  
, STRING_AGG(MilitaryFormation2.name, '->') WITHIN GROUP (GRAPH PATH) AS 
ReportFormations 
FROM   MilitaryFormation AS MilitaryFormation1 
, ReportsTo FOR PATH AS rt 
, MilitaryFormation FOR PATH  AS MilitaryFormation2 
WHERE  MATCH(SHORTEST_PATH(MilitaryFormation1(-(rt)->MilitaryFormation2)+)) 
AND MilitaryFormation1.name = N'10-� ������� �������� ���';

-- ����� ������� ������ ������� �����
DECLARE @MilitaryFormationFrom AS NVARCHAR(50) = N'22-� ����������� �������������� ��������'; 
DECLARE @MilitaryFormationTo   
AS NVARCHAR(50) = N'31-� �������� �����'; 
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

-- 0 ����� �������� ������
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
