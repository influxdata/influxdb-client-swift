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
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/OrganizationsAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/
cp -r "${SCRIPT_PATH}"/generated/InfluxDB2/Classes/OpenAPIs/APIs/UsersAPI.swift "${SCRIPT_PATH}"/../Sources/InfluxDBSwiftApis/Generated/APIs/

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

rm -rf "${SCRIPT_PATH}"/generated
