// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerinax/health.fhir.r4;

# Abstract Patient Matcher.
public type PatientMatcher isolated object {
    # Abstract Method to match patients.
    #
    # + patientMatchRequestData - Record to hold patient matching request data  
    # + config - Configuration Record for Patient Matching Algorithm
    # + return - Return Matched Patients
    public isolated function matchPatients(PatientMatchRequestData patientMatchRequestData, ConfigurationRecord config) returns error|r4:Bundle;
};

# Record to hold configrations of a PatientMatching Algorithm.
public type ConfigurationRecord record {
    # Base URL for the Source System.
    string baseURL;
    # Data Retriever type to be used in the patient matching algorithm
    DataRetriever dataRetriever;

};

# Record to hold the patient match request.
public type PatientMatchRequestData record {
    # resource type name
    string resourceType;
    # resource Id
    string id;
    # parameter resource in fhir specification
    json[] 'parameter;
};