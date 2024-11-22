/*What are the most optimal skills to learn (it's a in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrate on remote positions with specified salaries
- Why? Targets skills that offer job security and financial benefits, offering strategic insight
for career development in data analysis
*/
WITH skill_demand AS(
    SELECT 
        COUNT(skills_job_dim.skill_id) AS demand_count,
        skills_dim.skill_id,
        skills_dim.skills
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL 
        AND job_work_from_home = TRUE
    GROUP BY 
        skills_dim.skill_id
),
    average_salary AS(
    SELECT
        ROUND(AVG(salary_year_avg),0) AS avg_salary,
        skills_job_dim.skill_id
    FROM job_postings_fact 
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        salary_year_avg IS NOT NULL 
        AND job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
    GROUP BY 
        skills_job_dim.skill_id
)

SELECT 
    skill_demand.skill_id,
    skill_demand.skills,
    demand_count,
    avg_salary
FROM skill_demand
JOIN average_salary
ON skill_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY 
    avg_salary DESC, 
    demand_count DESC
LIMIT 25