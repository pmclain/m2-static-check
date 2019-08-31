## M2 Static Analysis Container

Container for running M2 Static Analysis and generating Allure result report.

### Usage

#### Arguments

| Argument | Description |
| --- | --- |
| `$1` | Remote repository to compare differences against |
| `$2` | Remote branch to compare differences against |
| `$3` | (Optional) Test run type, when empty `phpunit.xml.dist` is assumed. `all`: `phpunit-all.xml.dist` or `custom`: `phpunit.xml` |

#### Example usage

Running from M2 project root:

`docker run patmclain/m2-static-check -v$(pwd):/app https://github.com/magento/graphql-ce.git 2.3-develop`

Travis CI:
`docker run patmclain/m2-static-check -v$($TRAVIS_BUILD_DIR):/app https://github.com/magento/graphql-ce.git $TRAVIS_BRANCH`

#### Allure Output

Allure reports are generated in `{magneto_root}/dev/tests/static/allure-output/`
