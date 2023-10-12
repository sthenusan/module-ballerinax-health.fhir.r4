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

import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4utils.fhirpath as fhirpath;

const SEARCH_SET = "searchset";
const RESULT = "result";

# Implementation of the RuleBasedPatientMatching Algorithm.
public isolated class RuleBasedPatientMatcher {
    *PatientMatcher;
        public isolated function matchPatients(PatientMatchRequestData patientMatchRequestData, ConfigurationRecord config) returns error|r4:Bundle {
        
            json 'resource = patientMatchRequestData.'parameter[0];
            json countObject = patientMatchRequestData.'parameter[1];
            json onlyCertainMatchesObject = patientMatchRequestData.'parameter[2];

            string count = check countObject.valueInteger;
            int|error countInt = int:fromString(count);
            if countInt is error {
                return self.throwFHIRError("Error occurred while casting the patient count string to integer.", cause = countInt);
            }
            boolean|error onlyCertainMatches =  boolean:fromString(check onlyCertainMatchesObject.valueBoolean);
            if onlyCertainMatches is error {
                return self.throwFHIRError("Error occurred while casting the onlyCertainMatches flag from string to boolean.", cause = onlyCertainMatches);
            }
            international401:ParametersParameter[] paramArray=[];
            if config.hasKey("fhirpaths") {
                string [] fhirpaths = <string[]>config.get("fhirpaths");
                foreach string path in fhirpaths {
                    fhirpath:FhirPathResult fhirPathResult = fhirpath:getFhirPathResult('resource, path);
                    json evaluvatedResult = fhirPathResult?.result;
                    if !(evaluvatedResult is ()) {
                        paramArray.push({name: path, valueString: evaluvatedResult.toString()});
                    }
                }
                if paramArray.length() > 0{
                    international401:Parameters fhirParameters = {
                        'parameter : paramArray
                    };
                    return config.dataRetriever.getPatients(fhirParameters,config);
                }
            }
        return error("dwed");
    };


    isolated function throwFHIRError(string message, error? cause) returns r4:FHIRError {
        if cause is error {
            return r4:createFHIRError(message = message, errServerity = r4:ERROR,
                            code = r4:TRANSIENT_EXCEPTION, diagnostic = cause.detail().toString(), cause = cause, httpStatusCode = http:STATUS_BAD_REQUEST);
        }
        return r4:createFHIRError(message = message, errServerity = r4:ERROR,
                            code = r4:TRANSIENT_EXCEPTION, httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}


# Record to hold the configuration details for the rule based patient matching algorithm.
public type RuleBasedConfigurationRecord record {
    *ConfigurationRecord;
    # fhirpaths to be used in the patient matching algorithm 
    string[] fhirpaths?;
};

