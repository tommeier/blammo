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

  open('/tmp/changelog.yml', 'w') do |file|
    file << releases.to_yaml
  end
end

When /^I render the changelog as HTML$/ do
  options = {
    :quiet  => true,
    :force  => true,
    :input  => '/tmp/changelog.yml',
    :output => '/tmp/changelog.html'
  }
  Blammo::CLI.new({}, options).render
end

def response_body
  open('/tmp/changelog.html').read
end

Then /^I should see the following items within "([^\"]+)":$/ do |selector, table|
  # Match the tables exactly.
  options = {
    :missing_row => true,
    :surplus_row => true,
    :missing_col => true,
    :surplus_col => true
  }

  items = tableish("#{selector} li", lambda {|li| [li] })
  items.map! {|item| [item.first.gsub(/\s+/, " ")] }

  table.diff!(items, options)
end
