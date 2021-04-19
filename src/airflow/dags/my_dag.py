"""
### New definition of default loading pipeline
"""
# [START tutorial]
# [START import_module]
from datetime import timedelta

# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG

# Operators; we need this to operate!
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago

from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook

from airflow.operators.python import PythonOperator, PythonVirtualenvOperator

import logging

import pandas as pd

# [END import_module]

# [START default_args]
# These args will get passed on to each operator
# You can override them on a per-task basis during operator initialization
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
    # 'wait_for_downstream': False,
    # 'dag': dag,
    # 'sla': timedelta(hours=2),
    # 'execution_timeout': timedelta(seconds=300),
    # 'on_failure_callback': some_function,
    # 'on_success_callback': some_other_function,
    # 'on_retry_callback': another_function,
    # 'sla_miss_callback': yet_another_function,
    # 'trigger_rule': 'all_success'
}
# [END default_args]


# [START instantiate_dag]
dag = DAG(
    'my_DAG',
    default_args=default_args,
    description='A simple tutorial DAG',
    schedule_interval=timedelta(days=1),
    start_date=days_ago(2),
    tags=['example'],
)
# [END instantiate_dag]


# t1, t2 and t3 are examples of tasks created by instantiating operators
# [START basic_task]
t1 = BashOperator(
    task_id='print_date',
    bash_command='date',
    dag=dag,
)

t2 = BashOperator(
    task_id='sleep',
    depends_on_past=False,
    bash_command='sleep 5',
    retries=3,
    dag=dag,
)
# [END basic_task]

# [START documentation]
dag.doc_md = __doc__

t1.doc_md = """\
#### Task Documentation
You can document your task using the attributes `doc_md` (markdown),
`doc` (plain text), `doc_rst`, `doc_json`, `doc_yaml` which gets
rendered in the UI's Task Instance Details page.
![img](http://montcs.bloomu.edu/~bobmon/Semesters/2012-01/491/import%20soul.png)
"""
# [END documentation]

# [START jinja_template]
templated_command = """
{% for i in range(5) %}
    echo "{{ ds }}"
    echo "{{ macros.ds_add(ds, 7)}}"
    echo "{{ params.my_param }}"
{% endfor %}
"""

t3 = BashOperator(
    task_id='templated',
    depends_on_past=False,
    bash_command=templated_command,
    params={'my_param': 'Parameter I passed in'},
    dag=dag,
)

conn_db_src = PostgresHook(postgres_conn_id='PostgresNDoD')
sqlalchemy_engine = conn_db_src.get_sqlalchemy_engine()

create_nDoD_tables = PostgresOperator(
      task_id="create_nDoD_tables",
      postgres_conn_id="PostgresNDoD",
      sql="./sql/nDoD_schema.sql"
      )


def load_utp_group(filename, conn_db, schema_db, **kwargs):
    """Load data into db"""

    df = pd.read_csv(filename, sep=';')

    logging.info('CSV in pandas \n %s',df.head().to_string())

    conn = conn_db.connect()
    conn.execute("TRUNCATE TABLE ndod.utp_group CASCADE")
    df.to_sql('utp_group', con=conn_db, schema=schema_db, if_exists='append', chunksize=1000, index=False)

    #TO DO : close connection
    return 'Successfully inserted into DB'


load_data_utp_group = PythonOperator(
    task_id='load_group_utp',
    python_callable=load_utp_group,
    op_kwargs={'filename': '/opt/airflow/dags/data/group_utp.csv',
               'conn_db': sqlalchemy_engine,
               'schema_db': 'ndod'
               },
    dag=dag,
)

# [END jinja_template]

t1 >> [t2, t3] >> create_nDoD_tables >> load_data_utp_group
# [END tutorial]
