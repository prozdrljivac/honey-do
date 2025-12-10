# Tasks

## Separate API Concerns from Lambda Domain Logic

**Goal**: Move HTTP concerns (headers, status codes, CORS, validation) from Lambda functions to API Gateway.

**Plan**: `/Users/petar.cevriz/.claude/plans/warm-launching-mochi.md`

---

### Infrastructure Setup (Tasks 1-10)

- [ ] **Task 1**: Create `infrastructure/modules/api-gateway-lambda/schemas/` directory and README
- [ ] **Task 2**: Create `CreateTaskRequest.json` JSON schema
- [ ] **Task 3**: Create `validation.tf` with request validator and models
- [ ] **Task 4**: Add `cors_origins` and `enable_request_validation` variables to `variables.tf`
- [ ] **Task 5**: Update method responses in `main.tf` for multiple status codes (200, 201, 204, 400, 404, 500)
- [ ] **Task 6**: Update method configuration with request validation
- [ ] **Task 7**: Create `integration_responses.tf` for success responses
- [ ] **Task 8**: Add error integration responses (ValidationError→400, NotFoundError→404, ServerError→500)
- [ ] **Task 9**: Create `cors.tf` with OPTIONS methods
- [ ] **Task 10**: Update deployment triggers in `main.tf`

### Environment Configuration (Tasks 11-15)

- [ ] **Task 11**: Add `cors_origins` variable to dev environment
- [ ] **Task 12**: Update dev route configurations with new fields
- [ ] **Task 13**: Pass `cors_origins` to module
- [ ] **Task 14**: Deploy infrastructure (`terraform apply`)
- [ ] **Task 15**: Test infrastructure with existing Lambdas (verify backward compatibility)

### Lambda Migration (Tasks 16-24)

- [ ] **Task 16**: Create `backend/src/common/exceptions.py` (ValidationError, NotFoundError, ServerError)
- [ ] **Task 17**: Create `backend/src/common/helpers.py` (parse_request_body, get_path_parameter)
- [ ] **Task 18**: Write unit tests for helper functions
- [ ] **Task 19**: Migrate `list_tasks.py` to return data only
- [ ] **Task 20**: Update tests for `list_tasks.py`
- [ ] **Task 21**: Migrate `delete_task.py` to return None and throw exceptions
- [ ] **Task 22**: Write tests for `delete_task.py` exceptions
- [ ] **Task 23**: Migrate `create_task.py` to return task object
- [ ] **Task 24**: Write tests for `create_task.py` validation

### Testing & Validation (Tasks 25-28)

- [ ] **Task 25**: Test API Gateway request validation blocks invalid requests
- [ ] **Task 26**: Test CORS preflight (OPTIONS) requests
- [ ] **Task 27**: Test error response format consistency
- [ ] **Task 28**: Monitor CloudWatch metrics (verify cost optimization)

### Documentation & Cleanup (Tasks 29-30)

- [ ] **Task 29**: Update documentation (README files)
- [ ] **Task 30**: Mark this task complete

---

**Reference**: [AWS API Gateway Integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration)
