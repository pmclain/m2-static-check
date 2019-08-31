#!/bin/bash

REPO_URL=$1
BRANCH_NAME=$2
SCAN_TYPE=$3

if [ "$SCAN_TYPE" == "all" ] ; then
    TEST_CONFIG=phpunit-all.dist
elif [ "$SCAN_TYPE" == "custom" ] ; then
    TEST_CONFIG=phpunit.xml
else
    TEST_CONFIG=phpunit.xml.dist
fi

cd /app || exit 1
composer install

php dev/tests/static/get_github_changes.php \
  --output-file="/app/dev/tests/static/testsuite/Magento/Test/_files/changed_files_ce.txt" \
  --base-path="/app/" \
  --repo="$REPO_URL" \
  --branch="$BRANCH_NAME"

cd /app/dev/tests/static || exit 1
../../../vendor/bin/phpunit -c $TEST_CONFIG

mkdir -p /app/dev/tests/static/allure-output
allure generate -o /app/dev/tests/static/allure-output /app/dev/tests/static/var/allure-results/
