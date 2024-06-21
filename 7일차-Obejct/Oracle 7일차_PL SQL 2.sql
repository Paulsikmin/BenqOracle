-- 7일차 PL/SQL
-- Oracle's Procedural Language Extension to SQL의 약자
-- 1.개요
-- - 오라클 자체에 내장되어 있는 절차적 언어로써, SQL의 단점을 보완하여 SQL문장
-- 내에서 변수의 정의, 조건처리, 반복처리 등을 지원함.

-- 2. 구조(익명블록) -     블록문법
-- 1. 선언부(선택)       : DECLARE
-- 2. 실행부(필수)       : BEGIN
-- 3. 예외처리부(선택)   : EXCEPTION
-- 4. END;(필수)         : END;
-- 5. /(필수)            : /

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
END;
/

SET SERVEROUTPUT ON;

-- PL/SQL에서 변수쓰는 방법
DECLARE
    VID NUMBER;
BEGIN
    --VID := 1023;
    SELECT SALARY
    INTO VID
    FROM EMPLOYEE
    WHERE EMP_NAME = '선동이';
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || VID);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No DATA~');
END;
/
-- 2. PL/SQL 변수
DESC EMPLOYEE;
DECLARE
    VEMPNO EMPLOYEE.EMP_NO%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSAL   EMPLOYEE.SALARY%TYPE;
    VHDATE EMPLOYEE.HIRE_DATE%TYPE;
BEGIN
    SELECT EMP_NO, EMP_NAME, SALARY, HIRE_DATE
    INTO VEMPNO, VENAME, VSAL, VHDATE
    FROM EMPLOYEE
    WHERE EMP_ID = '200';
    DBMS_OUTPUT.PUT_LINE(VEMPNO || ' : ' || VENAME || ' : ' || VSAL || ' : ' || VHDATE);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No DATA~');
END;
/
-- @실습문제1
-- 사번, 사원명, 직급명을 담을 수 있는 참조변수(%TYPE)를 통해서
-- 송종기 사원의 사번, 사원명, 직급명을 익명블럭을 통해 출력하세요.

DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VJNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_NAME
    INTO VEMPID, VENAME, VJNAME
    FROM EMPLOYEE
    LEFT OUTER JOIN JOB USING(JOB_CODE)
    WHERE EMP_NAME = '송종기';
    DBMS_OUTPUT.PUT_LINE(VEMPID || ' : ' || VENAME || ' : ' || VJNAME);
END;
/

SET SERVEROUTPUT ON;

-- PL/SQL 입력 받기
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : ' || VEMP.EMP_ID || ', 이름 : ' || VEMP.EMP_NAME);
END;
/

-- @실습문제2
-- 사원번호를 입력받아서 해당 사원의 사원번호, 이름, 부서코드, 부서명을 출력하세요.
DECLARE
    -- 변수 작성
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDCODE EMPLOYEE.DEPT_CODE%TYPE;
    VDTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    -- 쿼리문 작성
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
    -- 변수에 쿼리문 결과값 매핑
    INTO VEMPID, VENAME, VDCODE, VDTITLE
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&EMP_ID';
    -- 결과 출력
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || VEMPID || ', 이름 : ' || VENAME || ', 부서코드 : ' || VDCODE || ', 부서명 : ' || VDTITLE);
END;
/

-- @실습문제3
-- EMPLOYEE 테이블에서 사번의 마지막 번호를 구한뒤 +1한 사번에 사용자로부터
-- 입력받은 이름, 주민번호, 전화번호, 직급코드, 급여등급을 등록하는 PL/SQL을 작성하시오.
-- 1. 마지막번호를 구하는 쿼리문은 어떻게 될 것인가?
SELECT MAX(EMP_ID) FROM EMPLOYEE;
-- 2. 마지막번호는 변수에 저장해서 레코드 등록시 사용
SELECT MAX(EMP_ID) 
INTO LAST_NUM
FROM EMPLOYEE;
-- 3. 이름 입력받고 주민번호 입력받고 전화번호 입력받고 직급코드 입력받고 급여등급 입력받아서
-- EMPLOYEE테이블에 INSERT하시오!
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
VALUES(LAST_NUM+1, '&NAME', '&EMPNO', '&PHONE', '&JOBCODE', '&SALLEVEL');

DECLARE
    LAST_NUM EMPLOYEE.EMP_ID%TYPE;
BEGIN
    -- 마지막 번호를 가져올 수 있는 쿼리문
    SELECT MAX(EMP_ID) 
    INTO LAST_NUM
    FROM EMPLOYEE;
    -- 마지막 번호에 +1을 해서 EMPLOYEE테이블에 등록하는 쿼리문
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(LAST_NUM+1, '&NAME', '&EMPNO', '&PHONE', '&JOBCODE', '&SALLEVEL');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('완료되었습니다.');
END;
/

SELECT * FROM EMPLOYEE ORDER BY EMP_ID DESC;
ROLLBACK;

-- == PL/SQL의 조건문
-- 1. IF (조건식) THEN (실행문) END IF;
-- @실습문제1
-- 사원번호를 입력받아서 사원의 사번, 이름, 급여, 보너스율을 출력하시오
-- 단, 직급코드가 J1인 경우 '저희 회사 대표님입니다.'를 출력하시오.
-- 사번 : 222
-- 이름 : 이태림
-- 급여 : 2460000
-- 보너스율 : 0.35
-- 저희 회사 대표님입니다.
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * 
    INTO EMP_INFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : ' ||  EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' ||  EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' ||  EMP_INFO.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' ||  EMP_INFO.BONUS*100||'%');
    
    IF (EMP_INFO.JOB_CODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('저희 회사 대표님입니다.');
    ELSE DBMS_OUTPUT.PUT_LINE('일반 직원입니다');
    END IF;
END;
/
-- 2. IF (조건식) THEN (실행문) ELSE (실행문) END IF;
-- @실습문제2
-- 사원번호를 입력받아서 사원의 사번, 이름, 부서명, 직급명을 출력하시오.
-- 단, 직급코드가 J1인 경우 '대표', 그 외에는 '일반직원'으로 출력하시오.
-- 사번 : 201
-- 이름 : 송종기
-- 부서명 : 총무부
-- 직급명 : 부사장
-- 소속 : 일반직원
DECLARE
    V_EMPID EMPLOYEE.EMP_ID%TYPE;
    V_ENAME EMPLOYEE.EMP_NAME%TYPE;
    V_DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    V_JNAME JOB.JOB_NAME%TYPE;
    V_JCODE JOB.JOB_CODE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, JOB_CODE
    INTO V_EMPID, V_ENAME, V_DTITLE, V_JNAME, V_JCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || V_EMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || V_ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || V_DTITLE);
    DBMS_OUTPUT.PUT_LINE('직급명 : ' || V_JNAME);
    
    
    IF (V_JCODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('소속 : 대표');
    ELSE DBMS_OUTPUT.PUT_LINE('소속 : 일반직원');
    END IF;
END;
/

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID = '202';

IF ( JOB_CODE = 'J1')
THEN DBMS_OUTPUT.PUT_LINE('대표');
ELSIF ( JOB_CODE = 'J2')
THEN DBMS_OUTPUT.PUT_LINE('부대표');
ELSE DBMS_OUTPUT.PUT_LINE('일반직원');
END IF;

-- 3. IF (조건식) THEN (실행문) ELSIF (조건식) THEN (실행문)
--    ELSIF (조건식) THEN (실행문) ELSE (실행문) END IF;
-- @실습문제3
-- 사번을 입력 받은 후 급여에 따라 등급을 나누어 출력하도록 하시오.
-- 그때 출력 값은 사번, 이름, 급여, 급여등급을 출력하시오.
-- 500만원 이상(그외) : A
-- 400만원 ~ 499만원 : B
-- 300만원 ~ 399만원 : C
-- 200만원 ~ 299만원 : D
-- 100만원 ~ 199만원 : E
-- 0만원 ~ 99만원 : F
DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL   EMPLOYEE.SALARY%TYPE;
    SLV   VARCHAR(2);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMPID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    SAL := SAL / 10000;
    IF(SAL BETWEEN 0 AND 99) 
    THEN SLV := 'F';
    ELSIF (SAL >= 100 AND SAL <= 199)
    THEN SLV := 'E';
    ELSIF (SAL >= 200 AND SAL <= 299)
    THEN SLV := 'D';    
    ELSIF (SAL >= 300 AND SAL <= 399)
    THEN SLV := 'C';
    ELSIF (SAL BETWEEN 400 AND 499)
    THEN SLV := 'B';    
    ELSE SLV := 'A';
    END IF;
    
    IF (SAL >= 500)
    THEN SLV := 'A';
    ELSIF (SAL BETWEEN 400 AND 499)
    THEN SLV := 'B';
    ELSIF (SAL >= 300 AND SAL <= 399)
    THEN SLV := 'C';
    ELSIF (SAL >= 200 AND SAL <= 299)
    THEN SLV := 'D';
    ELSIF (SAL >= 100 AND SAL <= 199)
    THEN SLV := 'E';    
    ELSE SLV := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('등급 : ' || SLV);
END;
/

SELECT * FROM EMPLOYEE;
-- ELSIF와 대응되는 CASE문
-- CASE 변수 
--   WHEN 값1 THEN 실행문1;
--   WHEN 값2 THEN 실행문2;
--   WHEN 값3 THEN 실행문3;
--   WHEN 값4 THEN 실행문4;
--   ELSE 실행문;
-- END CASE;
SAL := FLOOR(SAL / 1000000);
CASE SAL
    WHEN 0 THEN SLV := 'F';
    WHEN 1 THEN SLV := 'E';
    WHEN 2 THEN SLV := 'D';
    WHEN 3 THEN SLV := 'C';
    WHEN 4 THEN SLV := 'B';
    ELSE SLV := 'A';
END CASE;

-- == PL/SQL의 반복문













