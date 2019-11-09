# frozen_string_literal: true

require "pg"

describe "reports" do
  let(:conn) { PG.connect(dbname: "million-agents-anton-smagin") }
  before do
    conn.exec(
      %{
        CREATE TABLE reports
        (
            id int PRIMARY KEY,
            user_id int,
            reward int,
            created_at timestamp without time zone
        );
      }
    )

    conn.exec(
      %{
        INSERT INTO reports (id, user_id, reward, created_at) VALUES
         (1, 1, 200, '2018-01-01 00:00:00'),
         (2, 2, 100, '2018-01-01 00:00:00'),
         (3, 2, 100, '2019-01-01 00:00:00'),
         (4, 1, 200, '2019-01-01 00:00:00'),
         (5, 3, 100, '2019-02-02 00:00:00'),
         (6, 2, 101, '2019-01-01 00:00:00');
      }
    )
  end

  it "fetch 2019 reward sum for users that created first report at 2018" do
    result = conn.exec(
      %{
        SELECT user_id, sum(reward)
        FROM reports
        WHERE EXTRACT(YEAR FROM created_at) = '2019'
        AND user_id IN (
          SELECT user_id
          FROM reports
          GROUP BY user_id
          HAVING EXTRACT(YEAR FROM min(created_at)) = '2018'
        )
        GROUP BY user_id
      }
    )
    expect(result).to match_array(
      [
        { "user_id" => "1", "sum" => "200" },
        { "user_id" => "2", "sum" => "201" }
      ]
    )
  end

  after do
    conn.exec("DROP TABLE reports;")
  end
end
