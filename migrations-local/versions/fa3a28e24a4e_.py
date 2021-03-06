"""empty message

Revision ID: fa3a28e24a4e
Revises: 
Create Date: 2020-06-22 16:38:05.690856

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'fa3a28e24a4e'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('review', sa.Column('published_date', sa.DateTime(), nullable=True))
    op.add_column('review', sa.Column('watched_date', sa.DateTime(), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('review', 'watched_date')
    op.drop_column('review', 'published_date')
    # ### end Alembic commands ###
