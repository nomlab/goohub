# coding: utf-8

class GoohubCLI < Clian::Cli
  desc "test NAME", "Test command, NAME mean outlet name"

  def test(name)
    f = Goohub::DataStore.create(:file)
    p f
    p f.store(name, "test")
    p f.load(name)
    p f.keys
    # p f.delete(name)

  end

end# class GoohubCLI
