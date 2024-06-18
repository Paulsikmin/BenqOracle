-- 4일차 오라클 조인
-- 1. JOIN
--  - 두 개 이상의 테이블에서 연관성을 가지고 있는 데이터들을
--    따로 분류하여 새로운 가상의 테이블을 만듬
--  -> 여러 테이블의 레코드를 조합하여 하나의 레코드로 만듬
-- ANSI 표준 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
-- 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE 
, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- ANSI 표준 구문
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB.JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB
ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
-- 테이블에 별칭 부여
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE;
-- 조인하는 컬럼 같을때 USING 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, JOB_CODE
FROM EMPLOYEE E
JOIN JOB J
USING(JOB_CODE);

-- 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB.JOB_CODE, JOB_NAME
FROM EMPLOYEE
, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- @실습문제1
-- 부서명과 지역명을 출력하세요.
SELECT DEPT_TITLE, LOCAL_NAME 
FROM DEPARTMENT
JOIN LOCATION
ON LOCATION_ID = LOCAL_CODE;

-- @실습문제2
-- 사원명과 직급명을 출력하세요!
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE
JOIN JOB
USING(JOB_CODE);

-- @실습문제3
-- 지역명과 국가명을 출력하세요
SELECT LOCAL_CODE, NATIONAL_CODE, LOCAL_NAME FROM LOCATION;

SELECT LOCAL_NAME, NATIONAL_NAME 
FROM LOCATION
JOIN NATIONAL
USING(NATIONAL_CODE);

SELECT NATIONAL_CODE, NATIONAL_NAME FROM NATIONAL;

-- @JOIN 종합실습
--1. 주민번호가 1970년대 생이면서 성별이 여자이고, 
-- 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.

--2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.

--3. 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.

--4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

--5. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.

--6. 급여등급테이블의 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
-- (사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 조인할 것)
-- 데이터 없음!

--7. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.

--8. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오. 
--단, join과 IN 사용할 것

--9. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.(JOIN아님)





