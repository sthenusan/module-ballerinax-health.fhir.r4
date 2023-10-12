import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4;
import ballerinax/health.clients.fhir;
import ballerina/regex;

const PATIENT = "Patient";
configurable string baseUrl = "https://localhost:9443/fhir-server/api/v4";
fhir:FHIRConnectorConfig fhirConnectorConfig = {
    baseURL: baseUrl
};
final fhir:FHIRConnector fhirClient = check new (fhirConnectorConfig);

# Fhir Repository based Data Retriever.
public isolated class FhirRepoDataRetriever {
    *DataRetriever;
    public isolated function getPatients(international401:Parameters fhirParameters, ConfigurationRecord config) returns r4:Bundle|error {

        map<string[]> searchParamsMap = {};
        string[] searchParameterValue = [];
        international401:ParametersParameter[]? parameters = fhirParameters?.'parameter;
        if (parameters != null) {
            foreach international401:ParametersParameter param in parameters {
                searchParameterValue[0] = <string>param.valueString;
                string[] tokens = regex:split(<string>param.name, "\\.");
                string attributeName = tokens[tokens.length() - 1];
                searchParamsMap[attributeName] = searchParameterValue;
            }
        }
        fhir:FHIRResponse|fhir:FHIRError result = fhirClient->search(PATIENT, searchParamsMap);

        if (result is fhir:FHIRResponse) {
            return <r4:Bundle>result.'resource;
        }
        return result;

    }

}

