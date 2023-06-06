// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.

import ballerinax/health.fhir.r4;
import ballerina/http;
import ballerina/sql;

# Creating an instance of PatientMatcherRegistry to register and get PatientMatcher
public final PMRegistry patientMatcherRegistry = new PMRegistry();

# Abstract Method to match patients
#
# + sourcePatient - new Patient who is being added to the system  
# + config - Configuration for Patient Matching Algorithm
# + return - Return Value Description
public type MatchPatients isolated function (r4:Patient sourcePatient, json config) returns error|http:Response;

# Abstract Method to verify patients
#
# + sourcePatient - new Patient who is being added to the system  
# + targetPatient - old Patient who is already in the system  
# + config - Configuration for Patient Matching Algorithm
# + return - return true if the two patients are matched, false otherwise
public type VerifyPatient isolated function (r4:Patient sourcePatient, r4:Patient targetPatient, json config) returns error|http:Response;

# Abstract Method to get MPI DB Client
#
# + config - Configuration for Patient Matching Algorithm
# + return - return MPI DB Client
public type GetMpiDbClient isolated function (json config) returns sql:Client|error;

# Abstract Type for Patient Matcher
#
# + matchPatients - Abstract Method to match patients 
# + verifyPatient - Abstract Method to verify patients  
# + getMpiDbClient - Abstract Method to get MPI DB Client
public type PatientMatcherRecord record {
    MatchPatients matchPatients;
    VerifyPatient verifyPatient;
    GetMpiDbClient getMpiDbClient;
};
