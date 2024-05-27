WITH top_paying_jobs AS
(
    SELECT
        job_id,
        company_dim.name AS company_name,
        job_title,
        salary_year_avg
    FROM 
        job_postings_fact
    LEFT JOIN 
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND 
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
)
SELECT 
    COUNT (skills_job_dim.job_id) AS no_of_jobs,
    skills_dim.skills,
    AVG (top_paying_jobs.salary_year_avg) AS avg_salary
FROM
    top_paying_jobs
INNER JOIN 
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills 
ORDER BY
    no_of_jobs DESC
LIMIT 10