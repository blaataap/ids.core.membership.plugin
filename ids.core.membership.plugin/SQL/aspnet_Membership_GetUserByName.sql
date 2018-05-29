USE [GewaltigNet]
GO

/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByName]    Script Date: 29/05/2018 13:23:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[aspnet_Membership_GetUserByName]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier

    IF (@UpdateLastActivity = 1)
    BEGIN
        -- select user ID from aspnet_users table
        SELECT TOP 1 @UserId = u.UserGuid
        FROM    dbo.mp_users u
        WHERE    LOWER(@UserName) = u.LoweredEmail

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1

        UPDATE   dbo.mp_users
        SET      LastActivityDate = @CurrentTimeUtc
        WHERE    @UserId = UserGuid

        SELECT  u.LoginName, u.Email, u.PasswordQuestion, u.Comment, u.ProfileApproved,
                u.PasswordQuestion,
                u.DateCreated, u.LastLoginDate, u.LastActivityDate, u.LastPasswordChangedDate,
                u.UserGuid, u.IsLockedOut, u.LastLockoutDate, u.Name
        FROM    dbo.mp_users u
        WHERE  @UserId = u.UserGuid
    END
    ELSE
    BEGIN
        SELECT TOP 1 u.LoginName, u.Email, u.PasswordQuestion, u.Comment, u.ProfileApproved,
                u.PasswordQuestion,
                u.DateCreated, u.LastLoginDate, u.LastActivityDate, u.LastPasswordChangedDate,
                u.UserGuid, u.IsLockedOut, u.LastLockoutDate, u.Name
        FROM    dbo.mp_users u
        WHERE   LOWER(@UserName) = u.LoweredEmail

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1
    END

    RETURN 0
END
GO

