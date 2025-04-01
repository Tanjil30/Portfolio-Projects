
            -- VIEW THE TABLE --------

select * from [dbo].[Customer_Data]


---- FIND OUT THE PERCENTAGE OF MALE AND FEMALE USERS-----

select Gender, count(Gender) as TotalCount,
count(Gender) * 100.0 /  (select count(*) from [dbo].[Customer_Data] ) as Percentage
from [dbo].[Customer_Data]
group by Gender



--------- TYPES OF CONTRACTS BY USERS AND THEIR PERCENTAGE ----------------

select Contract, count(Contract)  as TotalContracts,
count(Contract) *100.0/ (select count(*) from Customer_Data) as Percentage
from [dbo].[Customer_Data]
group by Contract


----------------TOTAL REVENUE/PERCENTAGE REVENUE BY CUSTOMER STATUS-------------

select Customer_Status, count(Customer_Status) as TotalCustomers, SUM(Total_Revenue) as TotalRev,
sum(Total_Revenue) / (select sum(Total_Revenue) from Customer_Data) * 100.0 as RevPercent
from Customer_Data
group by Customer_Status




------------ HIGHEST CONTRIBUTION OF USERS BY STATE -----------
select State, count(State) as TotalCount, 
count(State) * 100.0 / (select count(*) from Customer_Data) as PercentUser
from Customer_Data
group by State
order by PercentUser desc


----DISTINCT FUNCTION------
select Distinct Internet_Type from Customer_Data



---- DATA CLEANING: CHECK NULLS IN EVERY COLUMN AND REMOVE/REPLACE THEM-------

Select 
   SUM(CASE WHEN Customer_ID is NULL THEN 1 ELSE 0 END) as Cutomer_ID_Null_Count,
   sum(case when Gender is NULL then 1 else 0 end) as Gender_NullCount,
   sum(case when Age is Null then 1 else 0 end) as Age_NullCount,
   sum(case when Married is Null then 1 else 0 end) as Married_NullCount,
   sum(case when State is Null then 1 else 0 end) as State_Null_Count,
   sum(case when Number_of_Referrals  is Null then 1 else 0 end) as Number_of_Referrals_NullCount,
   sum(case when Tenure_in_Months is Null then 1 else 0 end) as Tenure_in_Months_NullCount,
   sum(case when Value_Deal is Null then 1 else 0 end) as Value_Daeal_NullCount,
   sum(case when Phone_Service is Null then 1 else 0 end) as Phone_Service_NullCount,
   sum(case when Multiple_Lines is Null then 1 else 0 end) as Multiple_Lines_NullCount,
   sum(case when Internet_Service is Null then 1 else 0 end) as Internet_Service_NullCount,
   sum(case when Internet_Type is Null then 1 else 0 end) as Internet_Type_NullCount,
   sum(case when Online_Security is Null then 1 else 0 end) as Online_Security_NullCount,
   sum(case when Online_Backup is Null then 1 else 0 end) as Online_Backup_NullCount,
   sum(case when Device_Protection_Plan is Null then 1 else 0 end) as Device_Protection_Plan_NullCount,
   sum(case when Premium_Support is Null then 1 else 0 end) as Premium_Support_NullCount,
   sum(case when Streaming_TV is Null then 1 else 0 end) as Streaming_TV_NullCount,
   sum(case when Streaming_Movies is Null then 1 else 0 end) as Streming_Movies_NullCount,
   sum(case when Streaming_Music is Null then 1 else 0 end) as Streaming_Music_NullCount,
   sum(case when Contract is Null then 1 else 0 end) as Contract_NullCount,
   sum(case when Paperless_Billing is Null then 1 else 0 end) as Paperless_Billing_NullCount,
   sum(case when Payment_Method is Null then 1 else 0 end) as Payment_Method_NullCount,
   sum(case when Monthly_Charge is Null then 1 else 0 end) as Monthly_Charge_NullCount,
   sum(case when Total_Charges is Null then 1 else 0 end) as TotalCharges_NullCount,
   sum(case when Total_Refunds is Null then 1 else 0 end) as Total_Refunds_NullCount,
   sum(case when Total_Extra_Data_Charges is Null then 1 else 0 end) as Total_Extra_Data_Charges_NullCount,
   sum(case when Total_Long_Distance_Charges is Null then 1 else 0 end) as Total_Long_Distance_Charges_NullCount,
   sum(case when Total_Revenue is Null then 1 else 0 end) as Total_Revenue_NullCount,
   sum(case when Customer_Status is Null then 1 else 0 end) as Customer_Status_NullCount,
   sum(case when Churn_Category is Null then 1 else 0 end) as Churn_Category_NullCount,
   sum(case when Churn_Reason is Null then 1 else 0 end) as Churn_Reason_NullCount,
   sum(case when Unlimited_Data is Null then 1 else 0 end) as Unlimited_Data_NullCount
   from Customer_Data
   




   ------ CREATE A NEW PRODUCTION TABLE TO REPLACE THE NULL VALUES ------------


   SELECT 
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    ISNULL(Value_Deal, 'None') AS Value_Deal,
    Phone_Service,
    ISNULL(Multiple_Lines, 'No') As Multiple_Lines,
    Internet_Service,
    ISNULL(Internet_Type, 'None') AS Internet_Type,
    ISNULL(Online_Security, 'No') AS Online_Security,
    ISNULL(Online_Backup, 'No') AS Online_Backup,
    ISNULL(Device_Protection_Plan, 'No') AS Device_Protection_Plan,
    ISNULL(Premium_Support, 'No') AS Premium_Support,
    ISNULL(Streaming_TV, 'No') AS Streaming_TV,
    ISNULL(Streaming_Movies, 'No') AS Streaming_Movies,
    ISNULL(Streaming_Music, 'No') AS Streaming_Music,
    ISNULL(Unlimited_Data, 'No') AS Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    Monthly_Charge,
    Total_Charges,
    Total_Refunds,
    Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,
    ISNULL(Churn_Category, 'Others') AS Churn_Category,
    ISNULL(Churn_Reason , 'Others') AS Churn_Reason

into [PortfolioProjects].[dbo].[New_Customer_Data]-- New Table Name
from [PortfolioProjects].[dbo].[Customer_Data]


--------- VIEW FUNCTION FOR TEMPORARY DATA VIEW-----------

Create view VW_CustomerData as
  select * from New_Customer_Data where Customer_Status in ('Churned', 'Stayed')



Create view VW_JoinData as
  select * from New_Customer_Data where Customer_Status = 'Joined'
