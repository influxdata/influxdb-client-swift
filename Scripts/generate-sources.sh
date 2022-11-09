#!/usr/bin/env bash

#
# How to run script from ROOT path:
#   docker run --rm -it -v "${PWD}":/code -v ~/.m2:/root/.m2 -w /code maven:3-openjdk-8 /code/Scripts/generate-sources.sh
#

SCRIPT_PATH="$( cd "$(dirname "$0")" || exit ; pwd -P )"

rm -rf "${SCRIPT_PATH}"/generated

# Download and merge OSS and Cloud definition
rm -rf "${SCRIPT_PATH}"/oss.yml || true
rm -rf "${SCRIPT_PATH}"/cloud.yml || true
rm -rf "${SCRIPT_PATH}"/influxdb-clients-apigen || true
wget https://raw.githubusercontent.com/influxdata/openapi/master/contracts/oss.yml -O "${SCRIPT_PATH}/oss.yml"
wget https://raw.githubusercontent.com/influxdata/openapi/master/contracts/cloud.yml -O "${SCRIPT_PATH}/cloud.yml"
wget https://raw.githubusercontent.com/influxdata/openapi/master/contracts/invocable-scripts.yml -O "${SCRIPT_PATH}/invocable-scripts.yml"
git clone --single-branch --branch master https://github.com/bonitoo-io/influxdb-clients-apigen "${SCRIPT_PATH}/influxdb-clients-apigen"
mvn -f "$SCRIPT_PATH"/influxdb-clients-apigen/openapi-generator/pom.xml compile exec:java -Dexec.mainClass="com.influxdb.MergeContracts" -Dexec.args="$SCRIPT_PATH/oss.yml $SCRIPT_PATH/invocable-scripts.yml"
mvn -f "$SCRIPT_PATH"/influxdb-clients-apigen/openapi-generator/pom.xml compile exec:java -Dexec.mainClass="com.influxdb.AppendCloudDefinitions" -Dexec.args="$SCRIPT_PATH/oss.yml $SCRIPT_PATH/cloud.yml"

# Generate client
cd "${SCRIPT_PATH}"/ || exit
mvn org.openapitools:openapi-generator-maven-plugin:generate

#### sync generated swift files to src
mkdir -p "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/
mkdir -p "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
mkdir -p "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
mkdir -p "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
mkdir -p "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/

## delete old sources
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/APIHelper.swift
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/CodableHelper.swift
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/OpenISO8601DateFormatter.swift
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/*.swift
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/*.swift
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/*.swift
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/*.swift

## copy apis
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/AuthorizationsAPITokensAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/AuthorizationsAPI.swift
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/BucketsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/DBRPsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/HealthAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/PingAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/LabelsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/OrganizationsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/ReadyAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/SecretsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/SetupAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/TasksAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/UsersAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/VariablesAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/ScraperTargetsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/SourcesAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/

## copy models
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Authorizations.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/AuthorizationUpdateRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/AuthorizationPostRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Bucket.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Buckets.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/BucketLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/SchemaType.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/PostBucketRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/PatchBucketRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Links.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/UserLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/UsersLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Label.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LabelResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LabelsResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LabelMapping.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/RetentionRule.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/PatchRetentionRule.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Authorization.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/AuthorizationAllOfLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/AuthorizationLinks.swift
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Permission.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Resource.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceMember.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceMembers.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceMembersLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceOwner.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceOwners.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/AddResourceMemberRequestBody.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Organization.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Organizations.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/PostOrganizationRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/PatchOrganizationRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/OrganizationLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/SecretKeysResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/SecretKeysResponseAllOfLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/SecretKeys.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/User.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/UserResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/UserResponseLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Users.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/PasswordResetBody.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DBRP.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DBRPUpdate.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DBRPs.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DBRPCreate.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DBRPGet.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Ready.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/HealthCheck.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/IsOnboarding.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/OnboardingRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/OnboardingResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LabelCreateRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LabelUpdate.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Variable.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Variables.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/VariableLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/VariableProperties.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Run.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/RunLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Runs.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/RunManually.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Task.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/TaskLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/TaskStatusType.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Logs.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LogEvent.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Tasks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/TaskCreateRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/TaskUpdateRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ScraperTargetRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ScraperTargetResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ScraperTargetResponses.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ScraperTargetResponseAllOfLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Source.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Sources.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/SourceLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Query.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Dialect.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DeletePredicateRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Scripts.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Script.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ScriptCreateRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ScriptInvocationParams.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ScriptLanguage.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ScriptUpdateRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/

# copy supporting files
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/CodableHelper.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/OpenISO8601DateFormatter.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIHelper.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/JSONEncodingHelper.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/JSONDataEncoding.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/URLSessionImplementations.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Extensions.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/SynchronizedDictionary.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/

# post process sources
sed -i 's/Any]>/String]>/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/UsersAPI.swift
sed -i 's/Void?/[String: String]?/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/PingAPI.swift
sed -i 's/.success/let .success(response)/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/PingAPI.swift
sed -i 's/completion(()/completion(response.header/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/PingAPI.swift
sed -i 's/returning: ()/returning: response.header/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/PingAPI.swift
sed -i 's/AuthorizationsAPITokensAPI/AuthorizationsAPI/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/AuthorizationsAPI.swift
sed -i 's/extern: File? = nil, //' "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/Query.swift
sed -i '/self.extern = extern/d' "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/Query.swift
sed -i 's/Any/String/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/Query.swift
sed -i '/public var extern: File?/d' "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/Query.swift
sed -i 's/Set<Annotations>/Array<Annotations>/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/Dialect.swift
sed -i 's/Any/String/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwift/Generated/Models/ScriptInvocationParams.swift

rm -rf "${SCRIPT_PATH}"/generated
