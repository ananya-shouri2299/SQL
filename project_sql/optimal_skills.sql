WITH jobs_per_skills AS
(
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT (skills_job_dim.job_id) AS no_of_jobs
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
),
salary_per_skills AS
(
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND (AVG (job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
)
SELECT 
    jobs_per_skills.skill_id,
    jobs_per_skills.skills,
    jobs_per_skills.no_of_jobs,
    salary_per_skills.avg_salary
FROM
    jobs_per_skills
INNER JOIN  
    salary_per_skills ON jobs_per_skills.skill_id = salary_per_skills.skill_id
WHERE 
    avg_salary > 75000
ORDER BY
    no_of_jobs DESC,
    avg_salary DESC
LIMIT 100