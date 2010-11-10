INPUT_PATH  = '/tmp/changelog.yml'
OUTPUT_PATH = '/tmp/changelog.html'

# Fakes out the webrat response_body method and loads the body from the
# rendered changelog.
def response_body
  open(OUTPUT_PATH).read
end

Given /^a changelog exists with the following commits:$/ do |table|
  # Remap the table headers to be lower-case strings.
  table.map_headers!(table.headers.inject({}) {|hash, header|
    hash[header] = header.downcase
    hash
  })

  releases = []
  releases_hash = {}

  table.hashes.each do |hash|
    release = releases_hash[hash["release"]]
    unless release
      release = {hash["release"] => []}
      releases << release
      releases_hash[hash["release"]] = release
    end
    commits = release.first.last
    commit = {hash["sha"] => hash["message"]}
    commits << commit
  end

  open(INPUT_PATH, 'w') do |file|
    file << releases.to_yaml
  end
end

When /^I render the changelog as HTML$/ do
  options = {
    :quiet  => true,       # Stop thor from logging to stdout
    :force  => true,       # Don't prompt the user if the file already exists
    :input  => INPUT_PATH,
    :output => OUTPUT_PATH
  }
  Blammo::CLI.new({}, options).render
end

Then /^I should see the following items within "([^\"]+)":$/ do |selector, table|
  items = tableish("#{selector} li", lambda {|li| [li] })
  items.map! {|item| [item.first.gsub(/\s+/, " ")] }

  # Match the tables exactly.
  options = {
    :missing_row => true,
    :surplus_row => true,
    :missing_col => true,
    :surplus_col => true
  }

  table.diff!(items, options)
end
