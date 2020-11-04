#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" || exit ; pwd -P )"

rm -rf "${SCRIPT_PATH}"/generated

# Generate client
cd "${SCRIPT_PATH}"/ || exit
mvn org.openapitools:openapi-generator-maven-plugin:generate

#### sync generated swift files to src
mkdir "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/ || true
mkdir "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/ || true
mkdir "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/ || true

## delete old sources
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/*.swift
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/*.swift
rm -f "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/*.swift

## copy apis
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/AuthorizationsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/BucketsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/DBRPsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/HealthAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
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
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Bucket.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Buckets.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/BucketLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/PostBucketRequest.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Links.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/UserLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/InvitesLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Label.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LabelResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LabelsResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/LabelMapping.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/RetentionRule.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Authorization.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/AuthorizationAllOfLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/AuthorizationLinks.swift
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Permission.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Resource.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceMember.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceMembers.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceOwner.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/ResourceOwners.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/AddResourceMemberRequestBody.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Organization.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Organizations.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/OrganizationLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/SecretKeysResponse.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/SecretKeysResponseAllOfLinks.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/SecretKeys.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/User.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/Users.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/PasswordResetBody.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DBRP.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DBRPUpdate.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/DBRPs.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
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
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models/RunLog.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/
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

# copy supporting files
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIHelper.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/JSONEncodingHelper.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/JSONDataEncoding.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/CodableHelper.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/OpenISO8601DateFormatter.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/URLSessionImplementations.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Extensions.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/Models.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/SynchronizedDictionary.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/

# post process sources
sed -i 's/Any]>/String]>/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/UsersAPI.swift
sed -i 's/case orgID$/case orgID = "organization_id"/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/DBRP.swift
sed -i 's/case org$/case org = "organization"/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/DBRP.swift
sed -i 's/case bucketID$/case bucketID = "bucket_id"/' "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/Models/DBRP.swift

rm -rf "${SCRIPT_PATH}"/generated
