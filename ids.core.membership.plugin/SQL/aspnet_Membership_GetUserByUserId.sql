USE [GewaltigNet]
GO

/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByUserId]    Script Date: 29/05/2018 13:23:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[aspnet_Membership_GetUserByUserId]
    @UserId               uniqueidentifier,
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    IF ( @UpdateLastActivity = 1 )
    BEGIN
        UPDATE   dbo.mp_users
        SET      LastActivityDate = @CurrentTimeUtc
        FROM     dbo.mp_users
        WHERE    @UserId = UserGuid

        IF ( @@ROWCOUNT = 0 ) -- User ID not found
            RETURN -1
    END

    SELECT  u.LoginName, u.PasswordQuestion, u.Comment, u.ProfileApproved,
            u.DateCreated, u.LastLoginDate, u.LastActivityDate,
            u.LastPasswordChangedDate, u.Email, u.IsLockedOut,
            u.LastLockoutDate, u.Name
    FROM    dbo.mp_users u
    WHERE   @UserId = u.UserGuid

    IF ( @@ROWCOUNT = 0 ) -- User ID not found
       RETURN -1

    RETURN 0
END
GO

