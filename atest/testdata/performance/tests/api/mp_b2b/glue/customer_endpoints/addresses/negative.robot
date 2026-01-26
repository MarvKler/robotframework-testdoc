*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    customer-access    customer-account-management    spryker-core

*** Test Cases ***
######POST#####
Create_customer_address_with_missing_required_fields
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"address3": "${default.address3}"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    firstName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    lastName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    address1 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    address2 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    zipCode => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    city => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    iso2Code => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    isDefaultShipping => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    isDefaultBilling => This field is missing.

Create_customer_address_with_empty_fields
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "","firstName": "","lastName": "","address1": "","address2": "","address3": "","zipCode": "","city": "","country": "","iso2Code": "","company":"","phone": "","isDefaultShipping": "","isDefaultBilling": ""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    address1 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    address2 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    zipCode => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    city => This value should not be blank.

Create_customer_address_with_invalid_salutation
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "Fake","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    salutation =\u003E The value you selected is not a valid choice.

Create_customer_address_with_customer_reference_not_matching_token
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/${yves_second_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.

Create_customer_address_with_non_existing_customer_reference
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/DE--10000/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.

Create_customer_address_with_empty_customer_reference
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers//addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.

Create_customer_address_with_empty_type
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "","attributes": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

######GET#####
Get_non-existent_customer_address
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /customers/${yves_user.reference}/addresses/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Address was not found.

Get_other_customer_address_list
    [Setup]    Run keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_second_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /customers/${yves_second_user.reference}/addresses
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:     /customers/${yves_second_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204

Get_address_list_for_non-existent_customer
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /customers/fake/addresses
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.

Get_address_list_with_no_token
    When I send a GET request:    /customers/${yves_user.reference}/addresses
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Get_other_customer_address_by_id
    [Setup]    Run keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_second_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /customers/${yves_user.reference}/addresses/${address_uid}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Address was not found.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:     /customers/${yves_second_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204

Get_other_customer_address_by_id_and_reference
    [Setup]    Run keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_second_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /customers/${yves_second_user.reference}/addresses/${address_uid}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:     /customers/${yves_second_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204


######PATCH#####
Patch_customer_address_without_id
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a PATCH request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","phone": "${changed.phone}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Patch_customer_address_with_fake_id
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a PATCH request:    /customers/${yves_user.reference}/addresses/fake    {"data": {"type": "addresses","attributes": {"address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","phone": "${changed.phone}"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Address was not found.

Patch_another_customer_address
    [Setup]    Run keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_second_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a PATCH request:    /customers/${yves_user.reference}/addresses/${address_uid}    {"data": {"type": "addresses","attributes": {"address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","phone": "${changed.phone}"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Address was not found.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:     /customers/${yves_second_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204

Patch_another_customer_address_by_id_using_reference
    [Setup]    Run keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_second_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a PATCH request:    /customers/${yves_second_user.reference}/addresses/${address_uid}    {"data": {"type": "addresses","attributes": {"address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","phone": "${changed.phone}"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:     /customers/${yves_second_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204

Patch_customer_address_with_no_reference
    [Setup]    Run keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I send a PATCH request:    /customers//addresses/${address_uid}    {"data": {"type": "addresses","attributes": {"address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","phone": "${changed.phone}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204

Patch_customer_address_with_wrong_reference
    [Setup]    Run keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I send a PATCH request:    /customers/DE--1/addresses/${address_uid}    {"data": {"type": "addresses","attributes": {"address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","phone": "${changed.phone}"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204

Patch_customer_address_with_empty_required_fields
    [Setup]    Run keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I send a PATCH request:    /customers/${yves_user.reference}/addresses/${address_uid}    {"data": {"type": "addresses","attributes": {"salutation": null,"firstName": null,"lastName": null, "address1": null,"address2": null,"zipCode": null,"city": null,"iso2Code": null}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    address1 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    address2 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    zipCode => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    city => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    iso2Code => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204


Patch_customer_address_with_invalid_salutation
    [Setup]    Run keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I send a PATCH request:    /customers/${yves_user.reference}/addresses/${address_uid}    {"data": {"type": "addresses","attributes": {"salutation": "Fake"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    salutation =\u003E The value you selected is not a valid choice.
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204


######DELETE#####
Delete_customer_address_with_wrong_id
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a DELETE request:    /customers/${yves_user.reference}/addresses/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Address was not found.

Delete_customer_address_with_no_id
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a DELETE request:    /customers/${yves_user.reference}/addresses
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_other_customer_address_by_id
    [Setup]    Run keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /customers/${yves_second_user.reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","country": "${default.country}","iso2Code": "${default.iso2Code}","company":"${default.company}","phone": "${default.phone}","isDefaultShipping": ${default.shipping_status},"isDefaultBilling": ${default.billing_status}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a DELETE request:    /customers/${yves_user.reference}/addresses/${address_uid}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Address was not found.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:     /customers/${yves_second_user.reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204
