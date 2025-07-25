---
name: Coverage-Driven Development Pattern
module_type: pattern
scope: context
priority: medium
triggers: ["CDD", "coverage driven", "coverage-driven development", "code coverage", "coverage first"]
dependencies: ["core/principles.md", "processes/testing/coverage-analysis.md"]
conflicts: ["patterns/development/tdd-pattern.md"]
version: 1.0.0
---

# Coverage-Driven Development (CDD) Pattern

## Purpose
Develop software by focusing on achieving comprehensive code coverage, identifying untested paths, and systematically addressing coverage gaps. This pattern emphasizes measuring and improving test coverage metrics while building features.

## Core Principles

1. **Coverage Visibility**: Always know current coverage metrics
2. **Gap-Driven Testing**: Target untested code paths first
3. **Meaningful Coverage**: Focus on valuable tests, not just numbers
4. **Incremental Improvement**: Continuously increase coverage
5. **Risk-Based Priority**: Test critical paths first

## Implementation

### Overview
CDD reverses the traditional TDD approach by writing implementation first, then using coverage analysis to guide test creation. This can be effective for exploring solutions or when working with existing codebases.

### Rules

#### Development Phase Rules
1. **Write implementation first**
   - Focus on solving the problem
   - Don't worry about tests initially
   - Create working solution

2. **Measure coverage immediately**
   - Run coverage tools after implementation
   - Identify all uncovered lines
   - Prioritize by risk and complexity

3. **Write tests for gaps**
   - Target lowest coverage areas
   - Focus on critical paths first
   - Ensure tests are meaningful

4. **Iterate until target reached**
   - Set realistic coverage goals (80-90%)
   - Don't aim for 100% blindly
   - Focus on valuable coverage

#### Coverage Analysis Rules
1. **Use multiple metrics**
   - Line coverage: Basic metric
   - Branch coverage: Decision paths
   - Function coverage: API completeness
   - Mutation coverage: Test quality

2. **Identify coverage types**
   ```
   Coverage Priority:
     Critical paths (must have 95%+)
     Business logic (must have 90%+)
     Edge cases (should have 80%+)
     Error handling (should have 85%+)
     Utility code (nice to have 70%+)
   ```

3. **Regular coverage reviews**
   - Check coverage before commits
   - Track coverage trends
   - Prevent coverage regression

### Process Flow

```
1. Implement Feature
   �
2. Run Coverage Analysis
   �
3. Identify Gaps
   �
4. Prioritize Uncovered Code
   �
5. Write Targeted Tests
   �
6. Verify Coverage Increase
   �
7. Refactor if Needed
   �
8. Repeat Until Goal Met
```

### Example Implementation

```python
# Step 1: Implementation first
class ShoppingCart:
    def __init__(self):
        self.items = []
        self.discount = 0
    
    def add_item(self, item, quantity=1):
        if quantity <= 0:
            raise ValueError("Quantity must be positive")
        
        for _ in range(quantity):
            self.items.append(item)
    
    def calculate_total(self):
        subtotal = sum(item.price for item in self.items)
        
        if len(self.items) > 10:
            self.discount = 0.1
        
        return subtotal * (1 - self.discount)

# Step 2: Run coverage
# coverage run -m pytest
# coverage report
# >> 45% coverage - missing tests for errors and discounts

# Step 3: Write tests for gaps
def test_quantity_validation():
    cart = ShoppingCart()
    with pytest.raises(ValueError):
        cart.add_item(item, quantity=0)

def test_bulk_discount():
    cart = ShoppingCart()
    # Add 11 items to trigger discount
    for _ in range(11):
        cart.add_item(Item(price=10))
    assert cart.calculate_total() == 99  # 110 - 10%

# Step 4: Re-run coverage
# >> 85% coverage - good enough for this module
```

## When to Apply

### Ideal Scenarios
- **Existing codebases**: Adding tests to legacy code
- **Exploration phase**: When solution unclear
- **Complex algorithms**: Where implementation comes first
- **Refactoring preparation**: Building safety net
- **Spike solutions**: Quick prototypes needing tests

### Not Recommended For
- **New greenfield projects**: TDD usually better
- **Clear requirements**: When behavior is well-defined
- **API design**: When interface matters most
- **Learning testing**: TDD teaches better habits

## Benefits

- **Pragmatic approach**: Ship working code faster
- **Legacy code friendly**: Works with existing systems
- **Visible progress**: Coverage metrics show improvement
- **Risk mitigation**: Focus tests on critical areas
- **Flexible process**: Adapt to project needs

## Trade-offs

### Advantages
-  Faster initial development
-  Clear progress metrics
-  Works with any codebase
-  Prioritizes important tests
-  Reduces over-testing

### Disadvantages
- L May miss design issues
- L Tests can be implementation-focused
- L Coverage != quality
- L Can encourage metric gaming
- L Less design pressure

## Anti-Patterns

### Coverage Gaming
L Writing meaningless tests just for coverage
```python
def test_init():  # Bad: tests nothing meaningful
    obj = MyClass()
    assert obj is not None
```

 Write tests that verify behavior
```python
def test_initialization_state():
    obj = MyClass()
    assert obj.status == 'ready'
    assert obj.queue.empty()
```

### 100% Coverage Obsession
L Forcing coverage of trivial code
 Focus on valuable coverage over perfect metrics

### Test After Ship
L Deploying untested code "temporarily"
 Always achieve minimum coverage before release

### Implementation-Coupled Tests
L Tests that break with any refactoring
 Test behavior and contracts, not implementation

## Integration

### With CI/CD
```yaml
# Example GitHub Actions
coverage:
  steps:
    - run: pytest --cov=src --cov-report=xml
    - uses: codecov/codecov-action@v3
      with:
        fail_ci_if_error: true
        threshold: 80%  # Minimum acceptable
```

### With Development Workflow
1. Feature branches must maintain or increase coverage
2. PR checks enforce coverage thresholds
3. Coverage reports in code review
4. Track coverage trends over time

## Metrics and Goals

### Coverage Targets by Code Type
- **Core Business Logic**: 90-95%
- **API Endpoints**: 85-90%
- **Data Models**: 80-85%
- **Utilities**: 70-80%
- **UI Components**: 60-70%
- **Configuration**: 50-60%

### Quality Metrics Beyond Coverage
- **Mutation Score**: Test effectiveness
- **Cyclomatic Complexity**: Code simplicity
- **Test Execution Time**: Maintainability
- **Defect Detection Rate**: Real-world effectiveness

## Tooling

### Coverage Tools by Language
- **Python**: coverage.py, pytest-cov
- **JavaScript**: Jest, Istanbul/nyc
- **Java**: JaCoCo, Cobertura
- **Go**: Built-in cover tool
- **Ruby**: SimpleCov

### Analysis Tools
- **SonarQube**: Combined metrics
- **Codecov**: Coverage tracking
- **Coveralls**: PR integration
- **Codacy**: Quality analysis

## Migration Strategy

### From No Tests to CDD
1. Set baseline coverage (often 0%)
2. Target +5% coverage per sprint
3. Focus on new code first
4. Gradually add tests to legacy code
5. Celebrate milestones

### From CDD to TDD
1. Start writing tests first for new features
2. Keep coverage discipline
3. Refactor tests to be behavior-focused
4. Gradually adopt TDD practices
5. Maintain coverage standards

---
*Coverage-Driven Development provides a pragmatic path to well-tested code by making test gaps visible and actionable.*