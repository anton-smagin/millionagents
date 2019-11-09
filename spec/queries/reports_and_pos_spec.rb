# frozen_string_literal: true

require "pg"

describe "reports and postions" do
  let(:conn) { PG.connect(dbname: "million-agents-anton-smagin") }

  before do
    conn.exec(
      %{
        CREATE TABLE pos
        (
            id int PRIMARY KEY,
            title character varying
        );

        CREATE TABLE reports
        (
            id int PRIMARY KEY,
            barcode character varying,
            price float,
            pos_id int
        );
      }
    )

    conn.exec(
      %{
        INSERT INTO pos (id, title) VALUES
          (1, 'magnit'),
          (2, 'magnit'),
          (3, 'pyaterochka'),
          (4, 'pyaterochka');
      }
    )

    conn.exec(
      %{
        INSERT INTO reports (id, barcode, price, pos_id) VALUES
          (1, 'barcode1',  100, 1),
          (2, 'barcode2',  200, 2),
          (3, 'barcode3',  300, 3),
          (4, 'barcode4',  400, 4);
      }
    )
  end

  it "fetch barcodes and prices grouped by position titles" do
    result = conn.exec(
      %{
         SELECT
           pos.title,
           array_agg(reports.barcode) as barcodes,
           array_agg(reports.price) as prices
         FROM reports
         JOIN pos
         ON pos.id = reports.pos_id
         GROUP BY pos.title;
      }
    )
    expect(result).to match_array(
      [
        {
          "title" => "magnit",
          "barcodes" => "{barcode1,barcode2}",
          "prices" => "{100,200}"
        },
        {
          "title" => "pyaterochka",
          "barcodes" => "{barcode3,barcode4}",
          "prices" => "{300,400}"
        }
      ]
    )
  end

  after do
    conn.exec("DROP TABLE reports;")
    conn.exec("DROP TABLE pos;")
  end
end
