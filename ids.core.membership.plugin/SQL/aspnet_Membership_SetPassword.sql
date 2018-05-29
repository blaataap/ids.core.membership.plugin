USE [GewaltigNet]
GO

/****** Object:  StoredProcedure [dbo].[aspnet_Membership_SetPassword]    Script Date: 29/05/2018 13:25:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[aspnet_Membership_SetPassword]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @NewPassword      nvarchar(128),
    @PasswordSalt     nvarchar(128),
    @CurrentTimeUtc   datetime,
    @PasswordFormat   int = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserGuid
    FROM    dbo.mp_users u
    WHERE   u.LoweredEmail = LOWER(@UserName)

    IF (@UserId IS NULL)
        RETURN(1)

    UPDATE dbo.mp_users
    SET Pwd = @NewPassword,PasswordSalt = @PasswordSalt,
        LastPasswordChangedDate = @CurrentTimeUtc
    WHERE @UserId = UserId
    RETURN(0)
END
GO

