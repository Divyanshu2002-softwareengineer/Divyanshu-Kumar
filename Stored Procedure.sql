use Payroll_DB

--Non-Paremeterised stored Procedure
CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT *
    FROM Employees;
END; 
Exec GetAllEmployees

--Pamaterised stored Procedure
CREATE FUNCTION dbo.SplitString
(
    @String NVARCHAR(MAX), 
    @Delimiter CHAR(1)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT value 
    FROM STRING_SPLIT(@String, @Delimiter)
);
CREATE PROCEDURE GetPayrollsDetailForEmployees
    @EmployeeIDs NVARCHAR(MAX)  -- Comma-separated employee IDs
AS
BEGIN
    SELECT *
    FROM Payrolls
    WHERE EmployeeID IN (SELECT value FROM dbo.SplitString(@EmployeeIDs, ','));
END;
EXEC GetPayrollsDetailForEmployees @EmployeeIDs = '1,2,3,4,5';

--Stored Procedure with try catch
CREATE PROCEDURE InsertPayrollRecord
    @EmployeeID INT,
    @GrossPay DECIMAL(18, 2),
    @PayDate DATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO Payrolls(EmployeeID, GrossPay, PaymentDate)
        VALUES (@EmployeeID, @GrossPay, @PayDate);

        PRINT 'Payroll record inserted successfully';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Error occurred while inserting payroll record:';
        PRINT @ErrorMessage;

        -- Optionally, rethrow the error if you want to propagate it
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
Exec InsertPayrollRecord
@EmployeeID=1,
@GrossPay=4230,
@PayDate='2024-09-15';

 select * from Payrolls