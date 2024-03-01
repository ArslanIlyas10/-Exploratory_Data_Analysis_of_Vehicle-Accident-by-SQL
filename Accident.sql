-- The Database Made by me was AcdntData with Two Table accident and Vehicle
Use AcdntData;
Select * from vehicle;
Select * from [dbo].[accident];

--Question 1: How many accidents have occurred in urban areas versus rural areas?
Select [Area], COUNT([AccidentIndex]) AS 'Total Accident'
From [dbo].[accident]
Group By [Area];

--Question 2: Which day of the week has the highest number of accidents?
Select [Day], COUNT([AccidentIndex]) AS 'Total Accident'
From [dbo].[accident]
Group By [Day]
Order By 'Total Accident' DESC;

--Question 3: What is the average age of vehicles involved in accidents based on their type?
Select [VehicleType], AVG ([AgeVehicle]) AS 'Average Year',COUNT([AccidentIndex]) AS 'Total Accident'
From [dbo].[vehicle]
Where  [AgeVehicle] Is Not Null
Group By [VehicleType]
Order By 'Total Accident' DESC;

--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
Select
        AgeGroup, 
        AVG ([AgeVehicle]) AS 'Average Year',
		COUNT([AccidentIndex]) AS 'Total Accident'
	From(
		Select [AgeVehicle],[AccidentIndex],
			Case
				When [AgeVehicle] between 0 AND 5 THEN 'New'
				When [AgeVehicle] between 6 AND 10 THEN 'Regular'
				Else 'Old' 
			End as AgeGroup
		From [dbo].[vehicle]
) AS SubQuery
Group By AgeGroup;

--Question 5: Are there any specific weather conditions that contribute to severe accidents?
Declare @Severity varchar(100)
Set @Severity = 'Fatal' --Serious, Fatal, Slight
Select [WeatherConditions], COUNT ([Severity])  AS 'Total Accident'
From [dbo].[accident]
Where [Severity] = @Severity
Group By [WeatherConditions]
Order BY 'Total Accident' Desc;

--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?

Select [LeftHand], COUNT([AccidentIndex]) AS 'Total Accident'
From [dbo].[vehicle]
Group By [LeftHand]
Having [LeftHand] Is Not Null
Order BY 'Total Accident' Desc;

--Question 7: Are there any relationships between journey purposes and the severity of accidents?
Select V.[JourneyPurpose], COUNT( A.[Severity] ) AS 'Total Accident',
Case
	When COUNT( A.[Severity] ) Between 0 AND 1000 Then 'Low'
	When COUNT( A.[Severity] ) Between 1001 AND 3000 Then 'Moderate'
	Else 'High'
End As 'High'
From [dbo].[accident] A
Join
[dbo].[vehicle] V  On A.[AccidentIndex] = V.[AccidentIndex]
Group By V.[JourneyPurpose]
Order BY 'Total Accident' Desc;

--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:
Declare @Light varchar (100)
Declare @Impact varchar (100)
Set @Light= 'Darkness' --Daylight, Darkness
Set @Impact= 'Offside' --Did not impact, Nearside, Front, Offside, Back
Select A.[LightConditions], V.[PointImpact], AVG ( V.[AgeVehicle]) AS 'Average Age'
From [dbo].[accident] A 
Join [dbo].[vehicle] V On A.[AccidentIndex] = V.[AccidentIndex]
Group By A.[LightConditions], V.[PointImpact]
Having A.[LightConditions]= @Light AND V.[PointImpact]= @Impact
Order By 'Average Age' DESC;
