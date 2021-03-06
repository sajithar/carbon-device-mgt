CREATE TABLE DM_DEVICE_TYPE (
     ID INTEGER IDENTITY NOT NULL,
     NAME VARCHAR(300) DEFAULT NULL,
     PRIMARY KEY (ID)
);

CREATE TABLE DM_DEVICE_CERTIFICATE (
      ID                    INTEGER IDENTITY NOT NULL,
      SERIAL_NUMBER            VARCHAR(500) DEFAULT NULL,
    	CERTIFICATE                  VARBINARY(max) DEFAULT NULL,
    	PRIMARY KEY (ID)
);

CREATE TABLE DM_DEVICE (
     ID                    INTEGER identity NOT NULL,
     DESCRIPTION           VARCHAR(max) DEFAULT NULL,
     NAME                  VARCHAR(100) DEFAULT NULL,
     DEVICE_TYPE_ID        INT DEFAULT NULL,
     DEVICE_IDENTIFICATION VARCHAR(300) DEFAULT NULL,
     TENANT_ID INTEGER DEFAULT 0,
     PRIMARY KEY (ID),
     CONSTRAINT fk_DM_DEVICE_DM_DEVICE_TYPE2 FOREIGN KEY (DEVICE_TYPE_ID )
     REFERENCES DM_DEVICE_TYPE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE DM_OPERATION (
    ID INTEGER IDENTITY NOT NULL,
    TYPE VARCHAR(50) NOT NULL,
    CREATED_TIMESTAMP DATETIME2(0) NOT NULL,
    RECEIVED_TIMESTAMP DATETIME2(0) NULL,
    OPERATION_CODE VARCHAR(1000) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE DM_CONFIG_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    OPERATION_CONFIG  VARBINARY(max) DEFAULT NULL,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_config FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE DM_COMMAND_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    ENABLED BIT NOT NULL DEFAULT 'FALSE',
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_command FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE DM_POLICY_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    ENABLED INTEGER NOT NULL DEFAULT 0,
    OPERATION_DETAILS VARBINARY(max) DEFAULT NULL,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_policy FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE DM_PROFILE_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    ENABLED INTEGER NOT NULL DEFAULT 0,
    OPERATION_DETAILS VARBINARY(max) DEFAULT NULL,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_profile FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE DM_ENROLMENT (
    ID INTEGER IDENTITY NOT NULL,
    DEVICE_ID INTEGER NOT NULL,
    OWNER VARCHAR(50) NOT NULL,
    OWNERSHIP VARCHAR(45) DEFAULT NULL,
    STATUS VARCHAR(50) NULL,
    DATE_OF_ENROLMENT DATETIME2(0) DEFAULT NULL,
    DATE_OF_LAST_UPDATE DATETIME2(0) DEFAULT NULL,
    TENANT_ID INT NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device_enrolment FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE DM_ENROLMENT_OP_MAPPING (
    ID INTEGER IDENTITY NOT NULL,
    ENROLMENT_ID INTEGER NOT NULL,
    OPERATION_ID INTEGER NOT NULL,
    STATUS VARCHAR(50) NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device_operation_mapping_device FOREIGN KEY (ENROLMENT_ID) REFERENCES
    DM_ENROLMENT (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_device_operation_mapping_operation FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE DM_DEVICE_OPERATION_RESPONSE (
    ID INTEGER IDENTITY NOT NULL,
    ENROLMENT_ID INTEGER NOT NULL,
    OPERATION_ID INTEGER NOT NULL,
    OPERATION_RESPONSE VARBINARY(max) DEFAULT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device_operation_response_enrollment FOREIGN KEY (ENROLMENT_ID) REFERENCES
    DM_ENROLMENT (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_device_operation_response_operation FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- POLICY RELATED TABLES --




CREATE  TABLE DM_PROFILE (
  ID INT NOT NULL IDENTITY ,
  PROFILE_NAME VARCHAR(45) NOT NULL ,
  TENANT_ID INT NOT NULL ,
  DEVICE_TYPE_ID INT NOT NULL ,
  CREATED_TIME DATETIME2(0) NOT NULL ,
  UPDATED_TIME DATETIME2(0) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT DM_PROFILE_DEVICE_TYPE
    FOREIGN KEY (DEVICE_TYPE_ID )
    REFERENCES DM_DEVICE_TYPE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);





CREATE  TABLE DM_POLICY (
  ID INT NOT NULL IDENTITY ,
  NAME VARCHAR(45) DEFAULT NULL ,
  DESCRIPTION VARCHAR(1000) NULL,
  TENANT_ID INT NOT NULL ,
  PROFILE_ID INT NOT NULL ,
  OWNERSHIP_TYPE VARCHAR(45) NULL,
  COMPLIANCE VARCHAR(100) NULL,
  PRIORITY INT NOT NULL,
  ACTIVE INT NOT NULL,
  UPDATED INT NULL,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_DM_PROFILE_DM_POLICY
    FOREIGN KEY (PROFILE_ID )
    REFERENCES DM_PROFILE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);




CREATE  TABLE DM_DEVICE_POLICY (
  ID INT NOT NULL IDENTITY ,
  DEVICE_ID INT NOT NULL ,
  ENROLMENT_ID INT NOT NULL,
  DEVICE VARBINARY(max) NOT NULL,
  POLICY_ID INT NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_POLICY_DEVICE_POLICY
    FOREIGN KEY (POLICY_ID )
    REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_DEVICE_DEVICE_POLICY
    FOREIGN KEY (DEVICE_ID )
    REFERENCES DM_DEVICE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);




CREATE  TABLE DM_DEVICE_TYPE_POLICY (
  ID INT NOT NULL ,
  DEVICE_TYPE_ID INT NOT NULL ,
  POLICY_ID INT NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_DEVICE_TYPE_POLICY
    FOREIGN KEY (POLICY_ID )
    REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_DEVICE_TYPE_POLICY_DEVICE_TYPE
    FOREIGN KEY (DEVICE_TYPE_ID )
    REFERENCES DM_DEVICE_TYPE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);





CREATE  TABLE DM_PROFILE_FEATURES (
  ID INT NOT NULL IDENTITY,
  PROFILE_ID INT NOT NULL,
  FEATURE_CODE VARCHAR(30) NOT NULL,
  DEVICE_TYPE_ID INT NOT NULL,
  TENANT_ID INT NOT NULL ,
  CONTENT VARBINARY(max) NULL DEFAULT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_DM_PROFILE_DM_POLICY_FEATURES
    FOREIGN KEY (PROFILE_ID)
    REFERENCES DM_PROFILE (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);




CREATE  TABLE DM_ROLE_POLICY (
  ID INT NOT NULL IDENTITY ,
  ROLE_NAME VARCHAR(45) NOT NULL ,
  POLICY_ID INT NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_ROLE_POLICY_POLICY
    FOREIGN KEY (POLICY_ID )
    REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);




CREATE  TABLE DM_USER_POLICY (
  ID INT NOT NULL IDENTITY ,
  POLICY_ID INT NOT NULL ,
  USERNAME VARCHAR(45) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT DM_POLICY_USER_POLICY
    FOREIGN KEY (POLICY_ID )
    REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


 CREATE  TABLE DM_DEVICE_POLICY_APPLIED (
  ID INT NOT NULL IDENTITY ,
  DEVICE_ID INT NOT NULL ,
  ENROLMENT_ID INT NOT NULL,
  POLICY_ID INT NOT NULL ,
  POLICY_CONTENT VARBINARY(max) NULL ,
  TENANT_ID INT NOT NULL,
  APPLIED SMALLINT NULL ,
  CREATED_TIME DATETIME2(0) NULL ,
  UPDATED_TIME DATETIME2(0) NULL ,
  APPLIED_TIME DATETIME2(0) NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_DM_POLICY_DEVCIE_APPLIED
    FOREIGN KEY (DEVICE_ID )
    REFERENCES DM_DEVICE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);



CREATE TABLE DM_CRITERIA (
  ID INT NOT NULL IDENTITY,
  TENANT_ID INT NOT NULL,
  NAME VARCHAR(50) NULL,
  PRIMARY KEY (ID)
);



CREATE TABLE DM_POLICY_CRITERIA (
  ID INT NOT NULL IDENTITY,
  CRITERIA_ID INT NOT NULL,
  POLICY_ID INT NOT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_CRITERIA_POLICY_CRITERIA
    FOREIGN KEY (CRITERIA_ID)
    REFERENCES DM_CRITERIA (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_POLICY_POLICY_CRITERIA
    FOREIGN KEY (POLICY_ID)
    REFERENCES DM_POLICY (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE DM_POLICY_CRITERIA_PROPERTIES (
  ID INT NOT NULL IDENTITY,
  POLICY_CRITERION_ID INT NOT NULL,
  PROP_KEY VARCHAR(45) NULL,
  PROP_VALUE VARCHAR(100) NULL,
  CONTENT VARBINARY(max) NULL ,
  PRIMARY KEY (ID),
  CONSTRAINT FK_POLICY_CRITERIA_PROPERTIES
    FOREIGN KEY (POLICY_CRITERION_ID)
    REFERENCES DM_POLICY_CRITERIA (ID)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE TABLE DM_POLICY_COMPLIANCE_STATUS (
  ID INT NOT NULL IDENTITY,
  DEVICE_ID INT NOT NULL,
  ENROLMENT_ID INT NOT NULL,
  POLICY_ID INT NOT NULL,
  TENANT_ID INT NOT NULL,
  STATUS INT NULL,
  LAST_SUCCESS_TIME DATETIME2(0) NULL,
  LAST_REQUESTED_TIME DATETIME2(0) NULL,
  LAST_FAILED_TIME DATETIME2(0) NULL,
  ATTEMPTS INT NULL,
  PRIMARY KEY (ID)
);


CREATE TABLE DM_POLICY_CHANGE_MGT (
  ID INT NOT NULL IDENTITY,
  POLICY_ID INT NOT NULL,
  DEVICE_TYPE_ID INT NOT NULL,
  TENANT_ID INT NOT NULL,
  PRIMARY KEY (ID)
);


CREATE TABLE DM_POLICY_COMPLIANCE_FEATURES (
  ID INT NOT NULL IDENTITY,
  COMPLIANCE_STATUS_ID INT NOT NULL,
  TENANT_ID INT NOT NULL,
  FEATURE_CODE VARCHAR(15) NOT NULL,
  STATUS INT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_COMPLIANCE_FEATURES_STATUS
    FOREIGN KEY (COMPLIANCE_STATUS_ID)
    REFERENCES DM_POLICY_COMPLIANCE_STATUS (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE DM_APPLICATION (
    ID INTEGER IDENTITY NOT NULL,
    NAME VARCHAR(150) NOT NULL,
    APP_IDENTIFIER VARCHAR(150) NOT NULL,
    PLATFORM VARCHAR(50) DEFAULT NULL,
    CATEGORY VARCHAR(50) NULL,
    VERSION VARCHAR(50) NULL,
    TYPE VARCHAR(50) NULL,
    LOCATION_URL VARCHAR(100) DEFAULT NULL,
    IMAGE_URL VARCHAR(100) DEFAULT NULL,
    APP_PROPERTIES VARBINARY(max) NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE DM_DEVICE_APPLICATION_MAPPING (
    ID INTEGER IDENTITY NOT NULL,
    DEVICE_ID INTEGER NOT NULL,
    APPLICATION_ID INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_application FOREIGN KEY (APPLICATION_ID) REFERENCES
    DM_APPLICATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- POLICY RELATED TABLES  FINISHED --

-- NOTIFICATION TABLE --
CREATE TABLE DM_NOTIFICATION (
    NOTIFICATION_ID INTEGER IDENTITY NOT NULL,
    DEVICE_ID INTEGER NOT NULL,
    OPERATION_ID INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    STATUS VARCHAR(10) NULL,
    DESCRIPTION VARCHAR(100) NULL,
    PRIMARY KEY (NOTIFICATION_ID),
    CONSTRAINT fk_dm_device_notification FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_operation_notification FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- NOTIFICATION TABLE END --
